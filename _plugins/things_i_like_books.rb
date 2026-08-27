# frozen_string_literal: true

require "csv"
require "json"
require "net/http"
require "uri"

module ThingsILike
  class BooksGenerator < Jekyll::Generator
    safe true
    priority :low

    RATING_BINS = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0].freeze

    def generate(site)
      config = site.config.fetch("things_i_like", {}).fetch("books", {})
      sheet_id = config["google_sheet_id"]
      gid = config.fetch("gid", 0)
      csv_url = ENV["THINGS_I_LIKE_BOOKS_CSV_URL"] || config["csv_url"] || google_sheet_csv_url(sheet_id, gid)

      books = csv_url ? fetch_books(csv_url) : []
      rated_books = books.select { |book| book["rating"] }
      top_books = enrich_top_books(rated_books.max_by(5) { |book| [book["rating"], book["title"].to_s] })

      site.data["things_i_like_books"] = {
        "source_url" => csv_url,
        "books" => books,
        "histogram" => histogram(rated_books),
        "top_books" => top_books,
      }
    rescue StandardError => e
      Jekyll.logger.warn "Things I Like:", "Could not fetch books sheet: #{e.message}"
      site.data["things_i_like_books"] = empty_data(e.message)
    end

    private

    def google_sheet_csv_url(sheet_id, gid)
      return nil if sheet_id.to_s.empty?

      "https://docs.google.com/spreadsheets/d/#{sheet_id}/export?format=csv&gid=#{gid}"
    end

    def fetch_books(csv_url)
      body = fetch_text(csv_url)
      raise "Book source returned a sign-in page. Publish the sheet to the web or provide THINGS_I_LIKE_BOOKS_CSV_URL." if body.include?("Sign in to your Google Account")

      rows = CSV.parse(body, headers: true)
      rows.filter_map { |row| normalize_book(row.to_h) }
    end

    def normalize_book(row)
      normalized = row.each_with_object({}) do |(key, value), result|
        result[normalize_key(key)] = value.to_s.strip
      end

      title = first_present(normalized, "title", "book", "name")
      return nil if title.to_s.empty?

      {
        "title" => title,
        "author" => first_present(normalized, "author", "authors", "writer"),
        "rating" => parse_rating(first_present(normalized, "rating", "score", "stars")),
        "date" => first_present(normalized, "date_read", "date_finished", "finished", "read", "date"),
      }.tap { |book| book["rating_label"] = rating_label(book["rating"]) if book["rating"] }
    end

    def normalize_key(key)
      key.to_s.downcase.strip.gsub(/[^a-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
    end

    def first_present(hash, *keys)
      keys.map { |key| hash[key] }.find { |value| !value.to_s.empty? }
    end

    def parse_rating(value)
      return nil if value.to_s.empty?

      text = value.to_s.strip
      if text.match?(/\A\d+(?:\.\d+)?\z/)
        rating = text.to_f
        return rating > 5 ? (rating / 20.0).round(2) : rating
      end

      fraction = text.match(%r{\A(\d+(?:\.\d+)?)/(\d+(?:\.\d+)?)\z})
      return nil unless fraction

      numerator = fraction[1].to_f
      denominator = fraction[2].to_f
      denominator.positive? ? ((numerator / denominator) * 5).round(1) : nil
    end

    def histogram(books)
      counts = RATING_BINS.to_h { |rating| [rating, 0] }
      books.each do |book|
        rating = nearest_half_star(book["rating"])
        counts[rating] += 1 if counts.key?(rating)
      end

      counts.map { |rating, count| { "rating" => rating, "label" => rating_label(rating), "count" => count } }
    end

    def nearest_half_star(rating)
      [[(rating.to_f * 2).round / 2.0, 0.5].max, 5.0].min
    end

    def rating_label(rating)
      rating == rating.to_i ? rating.to_i.to_s : rating.to_s
    end

    def enrich_top_books(books)
      books.map do |book|
        sleep 0.25
        wiki = wikipedia_match(book)
        book.merge(wiki)
      rescue StandardError => e
        Jekyll.logger.warn "Things I Like:", "Could not enrich #{book["title"]}: #{e.message}"
        book.merge("wikipedia_url" => wikipedia_search_url(book), "cover_url" => nil)
      end
    end

    def wikipedia_match(book)
      match = wikipedia_candidates(book).filter_map { |query| safe_wikipedia_query(query) }.first
      cover_url = match&.dig("thumbnail", "source") || open_library_cover_url(book)

      {
        "wikipedia_url" => match&.dig("fullurl") || fallback_wikipedia_url(book),
        "cover_url" => cover_url,
      }
    end

    def wikipedia_candidates(book)
      [
        wikipedia_title_alias(book["title"]),
        [book["title"], book["author"], "novel"].compact.join(" "),
        [book["title"], book["author"], "book"].compact.join(" "),
        [book["title"], "novel"].compact.join(" "),
        [book["title"], "book"].compact.join(" "),
      ].uniq
    end

    def wikipedia_title_alias(title)
      case title.to_s.downcase.strip
      when "100 years of solitude"
        "One Hundred Years of Solitude"
      when "lord of the rings trilogy"
        "The Lord of the Rings"
      when "the house of the spirit"
        "The House of the Spirits"
      else
        title
      end
    end

    def safe_wikipedia_query(query)
      wikipedia_query(query)
    rescue StandardError
      nil
    end

    def wikipedia_query(query)
      search_url = [
        "https://en.wikipedia.org/w/api.php?action=query",
        "generator=search",
        "gsrnamespace=0",
        "gsrlimit=1",
        "gsrsearch=#{escape(query)}",
        "prop=info|pageimages",
        "inprop=url",
        "piprop=thumbnail",
        "pithumbsize=330",
        "format=json",
      ].join("&")
      data = JSON.parse(fetch_text(search_url))
      data.dig("query", "pages")&.values&.first
    end

    def open_library_cover_url(book)
      return open_library_cover_alias_url(book["title"]) if open_library_cover_alias_url(book["title"])

      open_library_queries(book).filter_map do |query|
        search_url = "https://openlibrary.org/search.json?q=#{escape(query)}&limit=1"
        data = JSON.parse(fetch_text(search_url))
        data.dig("docs", 0, "cover_i")
      end.first&.then { |cover_id| "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg" }
    rescue StandardError
      nil
    end

    def open_library_queries(book)
      title = book["title"]
      title_alias = wikipedia_title_alias(title)
      author = book["author"]

      [
        [title_alias, author].compact.join(" "),
        [title, author].compact.join(" "),
        title_alias,
        title,
      ].uniq
    end

    def open_library_cover_alias_url(title)
      cover_id =
        case title.to_s.downcase.strip
        when "crime and punishment"
          "9411873"
        when "the house of the spirit"
          "3205226"
        when "100 years of solitude"
          "12627383"
        when "lord of the rings trilogy"
          "14625765"
        when "jane eyre"
          "8235363"
        end

      cover_id ? "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg" : nil
    end

    def wikipedia_search_url(book)
      query = [book["title"], book["author"], "book"].compact.join(" ")
      "https://en.wikipedia.org/wiki/Special:Search?search=#{escape(query)}"
    end

    def fallback_wikipedia_url(book)
      title = wikipedia_title_alias(book["title"])
      return wikipedia_search_url(book) if title.to_s.empty?

      "https://en.wikipedia.org/wiki/#{escape(title.tr(" ", "_"))}"
    end

    def fetch_text(url, redirects_remaining = 5)
      uri = URI(url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", read_timeout: 10, open_timeout: 10) do |http|
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = "jkmulq.github.io Jekyll build"
        http.request(request)
      end

      if response.is_a?(Net::HTTPRedirection)
        raise "too many redirects while fetching #{uri.host}" unless redirects_remaining.positive?

        return fetch_text(URI.join(uri, response["location"]).to_s, redirects_remaining - 1)
      end

      raise "#{uri.host} returned #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    end

    def escape(value)
      URI.encode_www_form_component(value.to_s)
    end

    def empty_data(message)
      {
        "source_url" => nil,
        "books" => [],
        "histogram" => histogram([]),
        "top_books" => [],
      }
    end
  end
end

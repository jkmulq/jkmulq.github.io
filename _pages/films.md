---
layout: page
title: films
permalink: /things-i-like/films/
description: i like movies, i wish i watched more
nav: false
nav_order: 3
---

<section class="letterboxd-page" data-letterboxd-username="{{ site.letterboxd.username }}">
  <p>
    a small window into the films ive seen. movies peak when the filmmaker uses the medium to its fullest extent. this usually means i like movies with minimalist dialogue, otherwise id read a book. let the actors act and the camera direct your attention. 
    
  </p>

  <div class="letterboxd-grid" hidden>
    <section class="letterboxd-panel">
      <h2>ratings</h2>
      <div class="letterboxd-histogram" data-letterboxd-distribution></div>
    </section>

    <section class="letterboxd-panel">
      <h2>movies i really liked recently</h2>
      <div class="letterboxd-movie-grid" data-letterboxd-high-rated-list></div>
    </section>
  </div>
</section>

<style>
  .letterboxd-page {
    --letterboxd-accent: color-mix(in srgb, var(--global-text-color) 35%, transparent);
    --letterboxd-muted: var(--global-text-color-light);
  }

  .letterboxd-grid {
    display: grid;
    grid-template-columns: minmax(0, 1fr);
    gap: 2rem;
    margin-top: 1.5rem;
  }

  .letterboxd-panel {
    margin-top: 1.5rem;
  }

  .letterboxd-panel h2 {
    font-size: 1.25rem;
    margin-bottom: 0.35rem;
  }

  .letterboxd-panel-note {
    color: var(--letterboxd-muted);
    font-size: 0.9rem;
    margin-bottom: 0.9rem;
  }

  .letterboxd-histogram {
    align-items: end;
    border-bottom: 1px solid var(--global-divider-color);
    display: grid;
    gap: 0.45rem;
    grid-template-columns: repeat(10, minmax(0, 1fr));
    min-height: 14rem;
    overflow: visible;
    padding-top: 1rem;
  }

  .letterboxd-bin {
    align-items: center;
    display: grid;
    gap: 0.35rem;
    grid-template-rows: 1.5rem minmax(2px, 1fr) 2.4rem;
    height: 100%;
    justify-items: center;
    min-width: 0;
  }

  .letterboxd-bin-count,
  .letterboxd-bin-label {
    color: var(--letterboxd-muted);
    font-size: 0.8rem;
    text-align: center;
  }

  .letterboxd-bin-bar {
    align-self: end;
    background: var(--letterboxd-accent);
    border-radius: 4px 4px 0 0;
    min-height: 2px;
    min-width: 2px;
    width: 100%;
  }

  .letterboxd-movie-grid {
    display: grid;
    gap: 1rem;
    grid-template-columns: repeat(auto-fit, minmax(8.5rem, 1fr));
  }

  .letterboxd-movie-card {
    min-width: 0;
  }

  .letterboxd-poster-frame {
    aspect-ratio: 2 / 3;
    background: color-mix(in srgb, var(--global-text-color) 7%, transparent);
    border-radius: 4px;
    display: block;
    margin-top: 0.45rem;
    overflow: hidden;
  }

  .letterboxd-poster-frame img {
    display: block;
    filter: none;
    height: 100%;
    object-fit: cover;
    width: 100%;
  }

  .letterboxd-poster-placeholder {
    align-items: center;
    color: var(--letterboxd-muted);
    display: flex;
    font-size: 0.85rem;
    height: 100%;
    justify-content: center;
    padding: 0.75rem;
    text-align: center;
  }

  .letterboxd-film-title {
    display: block;
    font-weight: 600;
    line-height: 1.25;
  }

  .letterboxd-film-meta {
    color: var(--letterboxd-muted);
    display: block;
    font-size: 0.9rem;
    margin-top: 0.15rem;
  }

  .letterboxd-film-date {
    color: var(--letterboxd-muted);
    display: block;
    font-size: 0.85rem;
    margin-top: 0.05rem;
  }

  @media (max-width: 700px) {
    .letterboxd-grid {
      grid-template-columns: 1fr;
    }

    .letterboxd-histogram {
      gap: 0.3rem;
      min-height: 11rem;
    }

    .letterboxd-bin-label {
      font-size: 0.72rem;
    }
  }
</style>

<script>
  (() => {
    const root = document.querySelector(".letterboxd-page");
    if (!root) return;

    const username = root.dataset.letterboxdUsername;
    const grid = root.querySelector(".letterboxd-grid");
    const distributionEl = root.querySelector("[data-letterboxd-distribution]");
    const highRatedList = root.querySelector("[data-letterboxd-high-rated-list]");

    const ratingLabels = [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5];
    const rssUrl = `https://letterboxd.com/${username}/rss/`;
    const proxyUrl = `https://api.rss2json.com/v1/api.json?rss_url=${encodeURIComponent(rssUrl)}`;

    const parseRating = (text) => {
      const rating = String(text || "").match(/(?:\u2605|\u00bd)+/u);
      if (!rating) return null;

      const stars = (rating[0].match(/\u2605/g) || []).length;
      const half = rating[0].includes("\u00bd") ? 0.5 : 0;
      return stars + half;
    };

    const parseTitle = (rawTitle) => {
      const titleWithoutRating = String(rawTitle || "").replace(/\s+-\s+(?:\u2605|\u00bd)+\s*$/u, "");
      const match = titleWithoutRating.match(/^(.*),\s*(\d{4})$/u);
      if (!match) return { displayTitle: titleWithoutRating, title: titleWithoutRating, year: "" };
      return { displayTitle: `${match[1]} (${match[2]})`, title: match[1], year: match[2] };
    };

    const parsePoster = (item) => {
      if (item.thumbnail) return item.thumbnail;

      const html = item.description || item.content || "";
      const doc = new DOMParser().parseFromString(html, "text/html");
      return doc.querySelector("img")?.src || "";
    };

    const normalizeItem = (item) => {
      const rating = parseRating(item.title) || parseRating(item.description);
      const parsedTitle = parseTitle(item.title);
      return {
        ...parsedTitle,
        rating,
        link: item.link,
        poster: parsePoster(item),
        date: item.pubDate ? new Date(item.pubDate) : null,
      };
    };

    const ratingText = (rating) => `${rating.toFixed(rating % 1 ? 1 : 0)} / 5`;

    const watchedDateText = (date) => {
      if (!date || Number.isNaN(date.getTime())) return "";

      return new Intl.DateTimeFormat("en", {
        day: "numeric",
        month: "short",
        year: "numeric",
      }).format(date);
    };

    const withTimeout = (promise, milliseconds, fallback) =>
      Promise.race([promise, new Promise((resolve) => setTimeout(() => resolve(fallback), milliseconds))]);

    const wikipediaSearchUrl = (film) => {
      const query = `${film.title} ${film.year} film`.trim();
      return `https://en.wikipedia.org/wiki/Special:Search?search=${encodeURIComponent(query)}`;
    };

    const lookupWikipediaUrl = (film) => {
      const query = `${film.title} ${film.year} film`.trim();
      const apiUrl = `https://en.wikipedia.org/w/api.php?action=opensearch&search=${encodeURIComponent(query)}&limit=1&namespace=0&format=json&origin=*`;

      return fetch(apiUrl)
        .then((response) => {
          if (!response.ok) throw new Error(`Wikipedia returned ${response.status}.`);
          return response.json();
        })
        .then((data) => data?.[3]?.[0] || wikipediaSearchUrl(film))
        .catch(() => wikipediaSearchUrl(film));
    };

    const appendFilmCard = (list, film) => {
      const card = document.createElement("article");
      const link = document.createElement("a");
      const title = document.createElement("span");
      const meta = document.createElement("span");
      const watchedDate = document.createElement("span");
      const posterFrame = document.createElement("span");

      card.className = "letterboxd-movie-card";
      link.href = wikipediaSearchUrl(film);
      link.rel = "noopener noreferrer";
      link.target = "_blank";

      title.className = "letterboxd-film-title";
      title.textContent = film.displayTitle;
      meta.className = "letterboxd-film-meta";
      meta.textContent = ratingText(film.rating);
      watchedDate.className = "letterboxd-film-date";
      watchedDate.textContent = watchedDateText(film.date);
      posterFrame.className = "letterboxd-poster-frame";

      if (film.poster) {
        const poster = document.createElement("img");
        poster.alt = `${film.displayTitle} poster`;
        poster.loading = "lazy";
        poster.src = film.poster;
        posterFrame.appendChild(poster);
      } else {
        const placeholder = document.createElement("span");
        placeholder.className = "letterboxd-poster-placeholder";
        placeholder.textContent = "Poster unavailable";
        posterFrame.appendChild(placeholder);
      }

      link.append(title, meta);
      if (watchedDate.textContent) link.appendChild(watchedDate);
      link.appendChild(posterFrame);
      card.appendChild(link);
      list.appendChild(card);

      withTimeout(lookupWikipediaUrl(film), 2500, wikipediaSearchUrl(film)).then((wikiUrl) => {
        link.href = wikiUrl;
      });
    };

    const renderDistribution = (films) => {
      const counts = new Map(ratingLabels.map((rating) => [rating, 0]));
      films.forEach((film) => counts.set(film.rating, (counts.get(film.rating) || 0) + 1));

      const maxCount = Math.max(...counts.values(), 1);
      distributionEl.replaceChildren();

      ratingLabels.forEach((rating) => {
        const count = counts.get(rating) || 0;
        const bin = document.createElement("div");
        const label = document.createElement("span");
        const bar = document.createElement("span");
        const value = document.createElement("span");

        bin.className = "letterboxd-bin";
        value.className = "letterboxd-bin-count";
        bar.className = "letterboxd-bin-bar";
        label.className = "letterboxd-bin-label";
        bar.style.height = `${(count / maxCount) * 100}%`;
        label.textContent = ratingText(rating);
        value.textContent = count;

        bin.append(value, bar, label);
        distributionEl.appendChild(bin);
      });
    };

    const render = (items) => {
      const films = items.map(normalizeItem).filter((film) => film.rating !== null);
      const highRatedFilms = films.filter((film) => film.rating >= 4.5);

      if (!films.length) {
        throw new Error("No rated films found in the RSS feed.");
      }

      renderDistribution(films);
      highRatedList.replaceChildren();

      if (highRatedFilms.length) {
        highRatedFilms.slice(0, 12).forEach((film) => appendFilmCard(highRatedList, film));
      } else {
        const empty = document.createElement("p");
        empty.textContent = "No 4.5- or 5-star ratings are available right now.";
        highRatedList.appendChild(empty);
      }

      grid.hidden = false;
    };

    fetch(proxyUrl)
      .then((response) => {
        if (!response.ok) throw new Error(`Letterboxd proxy returned ${response.status}.`);
        return response.json();
      })
      .then((data) => {
        if (data.status !== "ok" || !Array.isArray(data.items)) {
          throw new Error(data.message || "Letterboxd RSS data was unavailable.");
        }
        render(data.items);
      })
      .catch((error) => {
        console.error("Letterboxd highlights failed:", error);
      });
  })();
</script>

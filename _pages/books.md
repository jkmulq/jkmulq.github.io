---
layout: page
title: books
permalink: /things-i-like/books/
description: sometimes i read books, most of the time fiction. 

nav: false
---

{% assign books_data = site.data.things_i_like_books %}
{% assign max_count = 1 %}
{% for bin in books_data.histogram %}
  {% if bin.count > max_count %}
    {% assign max_count = bin.count %}
  {% endif %}
{% endfor %}

<section class="things-books-page">
  <p>
    i enjoy reading fiction. couple of fiction hot takes. firstly, i think it's ok when a movie adaptation significantly departs from the original book. i think that holds for the narrative, the characterisation, and sometimes the themes. reinterpret the text for me, don't show me how you think it should look like. secondly, i agree that the shorter the better (not controversial). maybe controversial: to justify extra length, you need to add more-than-proportional quality to make me want to read it. e.g. book A is twice the length of book B. book A needs to be more than twice as good as book B. 
  </p>

  <p class="things-books-status">{{ books_data.status }}</p>

  <div class="things-books-grid">
    <section class="things-books-panel">
      <h2>Rating histogram</h2>
      <div class="things-books-histogram">
        {% for bin in books_data.histogram %}
          {% assign height = bin.count | times: 100 | divided_by: max_count %}
          <div class="things-books-bin">
            <span class="things-books-bin-count">{{ bin.count }}</span>
            <span class="things-books-bin-bar" style="height: {{ height }}%"></span>
            <span class="things-books-bin-label">{{ bin.label }} / 5</span>
          </div>
        {% endfor %}
      </div>
    </section>

    <section class="things-books-panel">
      <h2>Top five books</h2>
      {% if books_data.top_books.size > 0 %}
        <div class="things-books-card-grid">
          {% for book in books_data.top_books %}
            <article class="things-books-card">
              <a href="{{ book.wikipedia_url }}" rel="noopener noreferrer" target="_blank">
                <span class="things-books-title">{{ book.title }}</span>
                {% if book.author %}
                  <span class="things-books-meta">{{ book.author }}</span>
                {% endif %}
                <span class="things-books-meta">{{ book.rating_label }} / 5</span>
                <span class="things-books-cover-frame">
                  {% if book.cover_url %}
                    <img src="{{ book.cover_url }}" alt="{{ book.title }} cover" loading="lazy">
                  {% else %}
                    <span class="things-books-cover-placeholder">Cover unavailable</span>
                  {% endif %}
                </span>
              </a>
            </article>
          {% endfor %}
        </div>
      {% else %}
        <p>No ranked books are available yet.</p>
      {% endif %}
    </section>
  </div>
</section>

<style>
  .things-books-page {
    --things-books-accent: color-mix(in srgb, var(--global-text-color) 35%, transparent);
    --things-books-muted: var(--global-text-color-light);
  }

  .things-books-status {
    color: var(--things-books-muted);
    margin: 1rem 0;
  }

  .things-books-grid {
    display: grid;
    gap: 1.25rem;
    grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
    margin-top: 1.5rem;
  }

  .things-books-panel {
    margin-top: 1.5rem;
  }

  .things-books-panel h2 {
    font-size: 1.25rem;
    margin-bottom: 0.35rem;
  }

  .things-books-histogram {
    align-items: end;
    border-bottom: 1px solid var(--global-divider-color);
    display: grid;
    gap: 0.45rem;
    grid-template-columns: repeat(10, minmax(0, 1fr));
    min-height: 14rem;
    padding-top: 1rem;
  }

  .things-books-bin {
    align-items: center;
    display: grid;
    gap: 0.35rem;
    grid-template-rows: 1.5rem minmax(2px, 1fr) 2.4rem;
    height: 100%;
    justify-items: center;
    min-width: 0;
  }

  .things-books-bin-count,
  .things-books-bin-label,
  .things-books-meta {
    color: var(--things-books-muted);
    font-size: 0.85rem;
  }

  .things-books-bin-label {
    text-align: center;
  }

  .things-books-bin-bar {
    align-self: end;
    background: var(--things-books-accent);
    border-radius: 4px 4px 0 0;
    min-height: 2px;
    min-width: 2px;
    width: 100%;
  }

  .things-books-card-grid {
    display: grid;
    gap: 1rem;
    grid-template-columns: repeat(auto-fit, minmax(8.5rem, 1fr));
  }

  .things-books-card {
    min-width: 0;
  }

  .things-books-title {
    display: block;
    font-weight: 600;
    line-height: 1.25;
  }

  .things-books-meta {
    display: block;
    margin-top: 0.15rem;
  }

  .things-books-cover-frame {
    aspect-ratio: 2 / 3;
    background: color-mix(in srgb, var(--global-text-color) 7%, transparent);
    border-radius: 4px;
    display: block;
    margin-top: 0.45rem;
    overflow: hidden;
  }

  .things-books-cover-frame img {
    display: block;
    height: 100%;
    object-fit: cover;
    width: 100%;
  }

  .things-books-cover-placeholder {
    align-items: center;
    color: var(--things-books-muted);
    display: flex;
    font-size: 0.85rem;
    height: 100%;
    justify-content: center;
    padding: 0.75rem;
    text-align: center;
  }

  @media (max-width: 700px) {
    .things-books-grid {
      grid-template-columns: 1fr;
    }

    .things-books-histogram {
      gap: 0.3rem;
      min-height: 11rem;
    }

    .things-books-bin-label {
      font-size: 0.72rem;
    }
  }
</style>

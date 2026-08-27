---
layout: page
title: art
permalink: /things-i-like/art/
description: A small gallery wall of art I keep coming back to.
nav: false
---

{% assign art = site.data.art %}

<section class="art-gallery">
  <p class="art-gallery-intro">
    a small wall of art i keep coming back to.
  </p>

  <div class="art-wall">
    {% for work in art %}
      {% assign frame_class = work.frame_class | default: 'is-medium' %}
      {% if work.image contains '://' %}
        {% assign image_src = work.image %}
      {% else %}
        {% assign image_src = work.image | relative_url %}
      {% endif %}
      <figure class="art-frame {{ frame_class }}" tabindex="0">
        <img src="{{ image_src }}" alt="{{ work.alt | default: work.title }}" loading="lazy" decoding="async">
        <figcaption class="art-caption">
          <span>{{ work.title }}</span>
          {% if work.artist %}
            <span>{{ work.artist }}</span>
          {% endif %}
          {% if work.date %}
            <span>{{ work.date }}</span>
          {% endif %}
        </figcaption>
      </figure>
    {% endfor %}
  </div>
</section>

<style>
  .art-gallery {
    margin-top: 1.25rem;
  }

  .art-gallery-intro {
    color: var(--global-text-color-light);
    max-width: 42rem;
  }

  .art-wall {
    align-items: start;
    display: grid;
    gap: 3.8rem 2.8rem;
    grid-auto-flow: dense;
    grid-template-columns: repeat(12, minmax(0, 1fr));
    margin: 3.5rem -2rem 0;
    padding: 1.6rem 2rem 3rem;
  }

  .art-frame {
    align-self: center;
    background: transparent;
    border: 0;
    box-shadow: none;
    display: grid;
    justify-self: center;
    min-height: 14rem;
    padding: 0;
    position: relative;
  }

  .art-frame img {
    display: block;
    filter: contrast(1.04) saturate(0.92);
    height: 100%;
    object-fit: contain;
    width: 100%;
  }

  .art-caption {
    background: color-mix(in srgb, var(--jkm-black) 88%, transparent);
    color: var(--jkm-paper);
    display: flex;
    font-size: 0.62rem;
    font-weight: 700;
    gap: 0.32rem;
    left: 0;
    line-height: 1;
    max-width: 100%;
    opacity: 0;
    overflow: hidden;
    padding: 0.3rem 0.38rem;
    pointer-events: auto;
    position: absolute;
    right: 0;
    text-overflow: ellipsis;
    top: 0;
    transition: opacity 0.15s ease;
    white-space: nowrap;
  }

  .art-caption span {
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .art-caption span + span::before {
    content: "/";
    margin-right: 0.32rem;
  }

  .art-caption:hover,
  .art-frame:focus .art-caption {
    opacity: 1;
  }

  .art-frame.is-small {
    grid-column: span 3;
    height: 15rem;
    width: 82%;
  }

  .art-frame.is-medium {
    grid-column: span 4;
    height: 21rem;
    width: 96%;
  }

  .art-frame.is-tall {
    grid-column: span 4;
    height: 28rem;
    width: 88%;
  }

  .art-frame.is-wide {
    grid-column: span 7;
    height: 18rem;
    width: 100%;
  }

  .art-frame.is-large {
    grid-column: span 6;
    height: 26rem;
    width: 94%;
  }

  .art-frame.is-bassman {
    grid-column: span 5;
    height: 31rem;
    width: 92%;
  }

  .art-frame.is-offset {
    margin-top: 4rem;
  }

  .art-frame.is-raised {
    margin-bottom: 3rem;
  }

  @media (max-width: 900px) {
    .art-wall {
      gap: 1.6rem;
      grid-template-columns: repeat(6, minmax(0, 1fr));
      margin-left: 0;
      margin-right: 0;
      padding: 0.85rem;
    }

    .art-frame.is-small,
    .art-frame.is-medium,
    .art-frame.is-tall,
    .art-frame.is-wide,
    .art-frame.is-large,
    .art-frame.is-bassman {
      grid-column: span 3;
      height: 19rem;
      margin-bottom: 0;
      margin-top: 0;
    }

    .art-frame.is-bassman {
      height: 25rem;
    }
  }

  @media (max-width: 575.98px) {
    .art-wall {
      display: block;
      padding: 0.75rem;
    }

    .art-frame {
      height: auto !important;
      margin: 0 0 2.2rem !important;
      min-height: 0;
    }

    .art-frame img {
      height: auto;
    }

    .art-caption {
      opacity: 1;
    }
  }
</style>

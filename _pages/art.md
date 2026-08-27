---
layout: page
title: art
permalink: /things-i-like/art/
nav: false
---

{% assign art = site.data.art %}

<section class="art-gallery">
  <p class="art-gallery-intro">
    a small wall of art i keep coming back to.
  </p>

  <div class="art-wall">
    <div class="art-row art-row-top">
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
      {% if forloop.index == 3 %}
    </div>
    <div class="art-row art-row-bottom">
      {% endif %}
    {% endfor %}
    </div>
  </div>
</section>

<style>
  .art-gallery {
    margin-top: 1.25rem;
  }

  .post-description:empty {
    display: none;
  }

  .art-gallery-intro {
    color: var(--global-text-color-light);
    max-width: 42rem;
  }

  .art-wall {
    background:
      linear-gradient(90deg, color-mix(in srgb, var(--jkm-flash) 7%, transparent) 0 1px, transparent 1px 100%),
      linear-gradient(180deg, color-mix(in srgb, var(--jkm-flash) 5%, transparent) 0 1px, transparent 1px 100%),
      linear-gradient(180deg, #211f19 0%, #12110e 100%);
    background-size: 5rem 5rem, 5rem 5rem, 100% 100%;
    display: flex;
    flex-direction: column;
    gap: clamp(0.75rem, 1.3vw, 1rem);
    margin: 2.5rem -2rem 0;
    padding: clamp(1.4rem, 3.5vw, 2.5rem);
  }

  .art-row {
    display: flex;
    gap: clamp(0.75rem, 1.3vw, 1rem);
    width: 100%;
  }

  .art-row-top {
    min-height: clamp(12rem, 27vw, 19rem);
  }

  .art-row-bottom {
    min-height: clamp(20rem, 46vw, 34rem);
  }

  .art-frame {
    align-self: center;
    background: transparent;
    border: 0;
    box-shadow: none;
    display: grid;
    justify-self: center;
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
    --art-ratio: 1;
  }

  .art-frame.is-medium {
    --art-ratio: 1;
  }

  .art-frame.is-tall {
    --art-ratio: 0.767;
  }

  .art-frame.is-wide {
    --art-ratio: 1.205;
  }

  .art-frame.is-large {
    --art-ratio: 0.862;
  }

  .art-frame.is-bassman {
    --art-ratio: 0.872;
    flex-grow: 1.08;
  }

  .art-row .art-frame {
    align-self: stretch;
    flex: var(--art-ratio) 1 0;
    height: auto;
    min-width: 0;
  }

  @media (max-width: 900px) {
    .art-wall {
      gap: 1.25rem;
      margin-left: 0;
      margin-right: 0;
      padding: 1.4rem;
    }

    .art-row {
      gap: 1.25rem;
    }

    .art-row-top,
    .art-row-bottom {
      min-height: 0;
    }
  }

  @media (max-width: 575.98px) {
    .art-wall {
      display: block;
      padding: 0.75rem;
    }

    .art-row {
      display: block;
    }

    .art-frame {
      height: auto !important;
      margin: 0 0 2.2rem !important;
      min-height: 0;
      width: 100%;
    }

    .art-frame img {
      height: auto;
    }

    .art-caption {
      opacity: 1;
    }
  }
</style>

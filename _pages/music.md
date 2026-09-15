---
layout: page
title: music
permalink: /things-i-like/music/
nav: false
---

<section class="records-like" aria-label="music i like">
  <header class="records-header">
    <div>
      <h2>music i like</h2>
    </div>
    <div class="records-count"><span id="records-counter">1 / 6</span></div>
  </header>

  <div class="records-layout">
    <div class="records-crate-panel">
        <div class="records-stage" id="recordsStage" aria-label="record browser">
        <div id="recordsStack"></div>
      </div>
    </div>

    <aside class="records-side-panel" aria-live="polite">
      <div>
        <h3 class="records-current-title" id="recordsCurrentTitle"></h3>
        <p class="records-current-artist" id="recordsCurrentArtist"></p>
        <div class="records-youtube" id="recordsCurrentYoutube"></div>
        <dl class="records-meta-list" id="recordsCurrentMeta"></dl>
        <div class="records-control-row">
          <button class="records-button" type="button" id="recordsPrev" aria-label="previous record">back</button>
          <button class="records-button records-focus-button" type="button" id="recordsOpen">pull out</button>
          <button class="records-button" type="button" id="recordsNext" aria-label="next record">next</button>
        </div>
      </div>

      <p class="records-source-note">
        <a href="https://www.discogs.com/" target="_blank" rel="noopener">data provided by Discogs</a>.
        this page uses Discogs API-derived metadata but is not affiliated with, sponsored or endorsed by Discogs.
        Discogs is a trademark of Zink Media, LLC.
      </p>
    </aside>
  </div>
</section>

<dialog class="records-dialog" id="recordsDialog" aria-labelledby="recordsDialogTitle">
  <div class="records-pullout">
    <div class="records-pullout-cover">
      <img id="recordsDialogImage" alt="">
    </div>
    <div class="records-pullout-copy">
      <div>
        <div class="records-kicker" id="recordsDialogKicker"></div>
        <h2 id="recordsDialogTitle"></h2>
        <p class="records-dialog-artist" id="recordsDialogArtist"></p>
      </div>
      <div class="records-youtube" id="recordsDialogYoutube"></div>
      <dl class="records-meta-list" id="recordsDialogMeta"></dl>
      <p class="records-discogs-line" id="recordsDialogAttribution"></p>
      <div class="records-pullout-actions">
        <button class="records-button" type="button" id="recordsDialogPrev">back</button>
        <button class="records-button" type="button" id="recordsDialogNext">next</button>
        <button class="records-button" type="button" id="recordsCloseDialog">return to crate</button>
      </div>
    </div>
  </div>
</dialog>

<style>
  .records-like,
  .records-dialog {
    --records-ink: var(--jkm-paper, #f3f0e8);
    --records-muted: var(--global-text-color-light, #8b857b);
    --records-edge: color-mix(in srgb, var(--jkm-paper, #f3f0e8) 18%, transparent);
    --records-line: color-mix(in srgb, var(--jkm-paper, #f3f0e8) 34%, transparent);
    --records-accent: #c9b17f;
    --records-shadow: rgba(0, 0, 0, 0.58);
  }

  .records-like {
    margin-top: 1.25rem;
  }

  .post-description:empty {
    display: none;
  }

  .records-header {
    align-items: end;
    border-bottom: 1px solid var(--records-edge);
    display: grid;
    gap: 1.25rem;
    grid-template-columns: minmax(0, 1fr) auto;
    margin-bottom: 1.75rem;
    padding-bottom: 1rem;
  }

  .records-header h2 {
    border-top: 0;
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(2.1rem, 5vw, 4.7rem);
    font-weight: 400;
    line-height: 0.92;
    margin: 0 0 0.65rem;
    padding-top: 0;
  }

  .records-header p {
    color: var(--records-muted);
    margin: 0;
    max-width: 42rem;
  }

  .records-count {
    align-items: center;
    color: var(--records-muted);
    display: flex;
    font-size: 0.78rem;
    gap: 0.65rem;
    letter-spacing: 0;
    white-space: nowrap;
  }

  .records-count::before {
    background: var(--records-line);
    content: "";
    height: 1px;
    width: 2.6rem;
  }

  .records-layout {
    align-items: stretch;
    display: grid;
    gap: 1.6rem;
    grid-template-columns: minmax(0, 1fr) minmax(15.5rem, 19.5rem);
    margin-left: calc((min(100vw, 1180px) - 100%) / -2);
    margin-right: calc((min(100vw, 1180px) - 100%) / -2);
  }

  .records-crate-panel {
    min-height: 34rem;
    overflow: hidden;
    padding-top: 1rem;
    position: relative;
  }

  .records-stage {
    cursor: grab;
    min-height: 31rem;
    perspective: 1250px;
    position: relative;
    touch-action: none;
    user-select: none;
  }

  .records-stage.is-dragging {
    cursor: grabbing;
  }

  .records-record {
    appearance: none;
    aspect-ratio: 1;
    background: #111;
    border: 1px solid rgba(255, 255, 255, 0.22);
    bottom: 2.875rem;
    box-shadow:
      0 2px 0 rgba(255, 255, 255, 0.08) inset,
      0 -1px 0 rgba(0, 0, 0, 0.4) inset,
      0 24px 46px var(--records-shadow);
    cursor: pointer;
    left: 50%;
    overflow: hidden;
    padding: 0;
    position: absolute;
    transform-origin: 50% 94%;
    transition: transform 260ms ease, filter 260ms ease, opacity 260ms ease;
    width: clamp(11.75rem, 31vw, 22rem);
    will-change: transform, filter;
  }

  .records-record::before {
    background:
      linear-gradient(115deg, rgba(255, 255, 255, 0.18), transparent 18%, transparent 72%, rgba(0, 0, 0, 0.28)),
      repeating-linear-gradient(0deg, rgba(255, 255, 255, 0.035) 0 1px, transparent 1px 7px);
    content: "";
    inset: 0;
    mix-blend-mode: screen;
    opacity: 0.42;
    pointer-events: none;
    position: absolute;
    z-index: 2;
  }

  .records-record::after {
    background: linear-gradient(0deg, rgba(0, 0, 0, 0.34), transparent);
    bottom: 0;
    content: "";
    height: 28%;
    inset-inline: 0;
    pointer-events: none;
    position: absolute;
    z-index: 3;
  }

  .records-record img {
    display: block;
    height: 100%;
    object-fit: cover;
    pointer-events: none;
    width: 100%;
  }

  .records-spine {
    background: linear-gradient(90deg, rgba(0, 0, 0, 0.42), rgba(255, 255, 255, 0.08), transparent);
    inset: 0 auto 0 0;
    position: absolute;
    width: 0.7rem;
    z-index: 4;
  }

  .records-sleeve-label {
    align-items: end;
    bottom: 0.65rem;
    color: rgba(255, 255, 255, 0.92);
    display: flex;
    font-size: 0.72rem;
    gap: 0.65rem;
    inset-inline: 0.75rem;
    justify-content: space-between;
    letter-spacing: 0;
    opacity: 0;
    pointer-events: none;
    position: absolute;
    text-shadow: 0 1px 8px rgba(0, 0, 0, 0.75);
    transform: translateY(0.5rem);
    transition: opacity 180ms ease, transform 180ms ease;
    z-index: 5;
  }

  .records-record.is-front .records-sleeve-label {
    opacity: 1;
    transform: translateY(0);
  }

  .records-side-panel {
    border-left: 1px solid var(--records-edge);
    display: grid;
    grid-template-rows: auto 1fr;
    min-height: 34rem;
    padding: 0.75rem 0 0 1.5rem;
  }

  .records-current-title {
    border-top: 0;
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(1.35rem, 2.2vw, 2.1rem);
    font-weight: 400;
    line-height: 1;
    margin: 0;
    padding-top: 0;
  }

  .records-current-artist,
  .records-dialog-artist {
    color: var(--records-muted);
    font-size: 1rem;
    margin: 0.5rem 0 0;
  }

  .records-meta-list {
    display: grid;
    gap: 0.85rem;
    margin: 1.5rem 0;
  }

  .records-meta-row {
    align-items: start;
    display: grid;
    font-size: 0.92rem;
    gap: 0.75rem;
    grid-template-columns: 5rem minmax(0, 1fr);
  }

  .records-meta-row dt {
    color: var(--records-muted);
    margin: 0;
  }

  .records-meta-row dd {
    margin: 0;
  }

  .records-control-row,
  .records-pullout-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 0.65rem;
  }

  .records-button {
    background: color-mix(in srgb, var(--records-ink) 4%, transparent);
    border: 1px solid var(--records-line);
    border-radius: 0;
    color: var(--records-ink);
    cursor: pointer;
    font: inherit;
    padding: 0.62rem 0.85rem;
  }

  .records-button:hover {
    background: color-mix(in srgb, var(--records-ink) 10%, transparent);
  }

  .records-focus-button {
    border-color: color-mix(in srgb, var(--records-accent) 56%, transparent);
  }

  .records-source-note,
  .records-discogs-line {
    border-top: 1px solid var(--records-edge);
    color: var(--records-muted);
    font-size: 0.78rem;
    line-height: 1.45;
    margin: 1.5rem 0 0;
    padding-top: 1rem;
  }

  .records-source-note {
    align-self: end;
  }

  .records-youtube {
    border-top: 1px solid var(--records-edge);
    display: grid;
    gap: 0.6rem;
    margin-top: 1rem;
    padding-top: 1rem;
  }

  .records-youtube-label {
    color: var(--records-muted);
    font-size: 0.77rem;
    letter-spacing: 0;
  }

  .records-youtube-card {
    aspect-ratio: 16 / 9;
    background: #050505;
    border: 1px solid rgba(242, 240, 234, 0.2);
    display: block;
    overflow: hidden;
    position: relative;
    text-decoration: none;
    width: 100%;
  }

  .records-youtube-card img {
    display: block;
    filter: saturate(0.92) brightness(0.82);
    height: 100%;
    object-fit: cover;
    opacity: 0.78;
    width: 100%;
  }

  .records-youtube-card:hover img {
    opacity: 0.9;
  }

  .records-youtube-play {
    background: radial-gradient(circle, rgba(0, 0, 0, 0.12), rgba(0, 0, 0, 0.48));
    color: var(--records-ink);
    display: grid;
    inset: 0;
    place-items: center;
    position: absolute;
  }

  .records-youtube-play span {
    background: rgba(0, 0, 0, 0.48);
    border: 1px solid rgba(242, 240, 234, 0.54);
    display: grid;
    font-size: 1.2rem;
    height: 2.75rem;
    line-height: 1;
    place-items: center;
    width: 3.875rem;
  }

  .records-youtube-title {
    color: var(--records-ink);
    font-size: 0.86rem;
    line-height: 1.35;
    text-decoration: underline;
    text-underline-offset: 3px;
  }

  .records-dialog {
    background: rgba(12, 11, 9, 0.97);
    border: 1px solid rgba(242, 240, 234, 0.24);
    box-shadow: 0 36px 100px rgba(0, 0, 0, 0.78);
    color: var(--records-ink);
    padding: 0;
    width: min(1040px, calc(100% - 28px));
  }

  .records-dialog::backdrop {
    backdrop-filter: blur(3px);
    background: rgba(0, 0, 0, 0.72);
  }

  .records-pullout {
    display: grid;
    grid-template-columns: minmax(260px, 0.98fr) minmax(260px, 0.72fr);
    min-height: 560px;
  }

  .records-pullout-cover {
    background:
      linear-gradient(135deg, rgba(255, 255, 255, 0.05), transparent 32%),
      linear-gradient(180deg, #17120f, #0b0a09);
    border-right: 1px solid var(--records-edge);
    display: grid;
    padding: 2rem;
    place-items: center;
  }

  .records-pullout-cover img {
    aspect-ratio: 1;
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 28px 70px rgba(0, 0, 0, 0.72);
    object-fit: cover;
    width: min(100%, 520px);
  }

  .records-pullout-copy {
    display: flex;
    flex-direction: column;
    gap: 1.1rem;
    padding: 2rem;
  }

  .records-pullout h2 {
    border-top: 0;
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(2rem, 4vw, 3.8rem);
    font-weight: 400;
    line-height: 0.94;
    margin: 0;
    padding-top: 0;
  }

  .records-kicker {
    color: var(--records-accent);
    font-size: 0.77rem;
    letter-spacing: 0;
    margin-bottom: 0.75rem;
  }

  .records-pullout-actions {
    margin-top: auto;
  }

  @media (max-width: 880px) {
    .records-header,
    .records-layout,
    .records-pullout {
      grid-template-columns: 1fr;
    }

    .records-layout {
      margin-left: 0;
      margin-right: 0;
    }

    .records-crate-panel {
      min-height: auto;
    }

    .records-stage {
      min-height: 31rem;
    }

    .records-side-panel {
      border-left: 0;
      border-top: 1px solid var(--records-edge);
      min-height: auto;
      padding: 1.4rem 0 0;
    }

    .records-pullout-cover {
      border-bottom: 1px solid var(--records-edge);
      border-right: 0;
    }
  }

  @media (max-width: 575.98px) {
    .records-header {
      gap: 0.8rem;
    }

    .records-count {
      white-space: normal;
    }

    .records-stage {
      min-height: 28rem;
    }

    .records-record {
      width: clamp(10.75rem, 62vw, 16.875rem);
    }

    .records-pullout-copy,
    .records-pullout-cover {
      padding: 1.35rem;
    }
  }
</style>

<script>
  (() => {
    const records = [
      {
        artist: "John Coltrane",
        title: "A Love Supreme",
        year: "1965",
        label: "Impulse!",
        format: "LP, album, stereo",
        style: "Modal / post-bop",
        discogs: "https://www.discogs.com/master/32287-John-Coltrane-A-Love-Supreme",
        cover: "https://archive.org/download/mbid-77701877-36ef-4b07-b24e-bc9f75673a0e/mbid-77701877-36ef-4b07-b24e-bc9f75673a0e-18854500235_thumb1200.jpg",
        coverCredit: "Cover Art Archive",
        youtubeId: "Y9-HmsN6KO4",
        youtubeTitle: "A Love Supreme Pt. I - Acknowledgement"
      },
      {
        artist: "Radium Dolls",
        title: "Wound Up",
        year: "2026",
        label: "Head Atlas / Hunting Ground Studios",
        format: "LP, album",
        style: "Garage rock / punk",
        discogs: "https://www.discogs.com/release/36372298-Radium-Dolls-Wound-Up",
        cover: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/ae/14/63/ae14635f-0df4-af2e-5f33-367af42a99f5/199806383018.jpg/1000x1000bb.jpg",
        coverCredit: "Apple Music / Radium Dolls",
        youtubeId: "mx0DDaReB0U",
        youtubeTitle: "Radio"
      },
      {
        artist: "Body Type",
        title: "Tally",
        year: "2026",
        label: "Poison City / p(doom)",
        format: "LP, album",
        style: "Alternative / indie rock",
        discogs: "https://www.discogs.com/master/4320078-Body-Type-Tally",
        cover: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/63/08/44/63084472-f7b2-497f-f5f5-c8a4331189ab/823375113379_Cover.jpg/1000x1000bb.jpg",
        coverCredit: "Apple Music / p(doom)",
        youtubeId: "5FFt9FkLw8M",
        youtubeTitle: "Eye Is A Mouth Is A Face"
      },
      {
        artist: "A Tribe Called Quest",
        title: "The Low End Theory",
        year: "1991",
        label: "Jive",
        format: "Album",
        style: "Jazzy hip-hop / boom bap",
        discogs: "https://www.discogs.com/master/45922-A-Tribe-Called-Quest-The-Low-End-Theory",
        cover: "https://archive.org/download/mbid-69959f4a-29fd-4867-83ec-bfb4036b30d1/mbid-69959f4a-29fd-4867-83ec-bfb4036b30d1-1672879787_thumb1200.jpg",
        coverCredit: "Cover Art Archive",
        youtubeId: "L1Zqol7ARCk",
        youtubeTitle: "The Low End Theory [Full Album]"
      },
      {
        artist: "Charles Mingus",
        title: "Tijuana Moods",
        year: "1962",
        label: "RCA Victor",
        format: "LP, album, mono",
        style: "Hard bop / post-bop",
        discogs: "https://www.discogs.com/master/176933-Charlie-Mingus-Tijuana-Moods",
        cover: "https://i.ebayimg.com/images/g/XacAAOSw8QlizkOt/s-l1200.png",
        coverCredit: "eBay listing image",
        youtubeId: "rQkNYAmJyE0",
        youtubeTitle: "Tijuana Moods (Complete Album)"
      },
      {
        artist: "Surprise Chef",
        title: "Superb",
        year: "2025",
        label: "Big Crown Records / College Of Knowledge Records",
        format: "LP, album, limited edition, stereo",
        style: "Soul / psychedelic funk",
        discogs: "https://www.discogs.com/master/3843831-Surprise-Chef-Superb",
        cover: "https://archive.org/download/mbid-faee04ad-fcad-4be5-a0c0-d6791bc709da/mbid-faee04ad-fcad-4be5-a0c0-d6791bc709da-42588861548_thumb500.jpg",
        coverCredit: "Cover Art Archive",
        youtubeId: "IuDDRK-rLXU",
        youtubeTitle: "Sleep Dreams"
      }
    ];

    const stage = document.getElementById("recordsStage");
    const stack = document.getElementById("recordsStack");
    const counter = document.getElementById("records-counter");
    const currentTitle = document.getElementById("recordsCurrentTitle");
    const currentArtist = document.getElementById("recordsCurrentArtist");
    const currentYoutube = document.getElementById("recordsCurrentYoutube");
    const currentMeta = document.getElementById("recordsCurrentMeta");
    const prevRecord = document.getElementById("recordsPrev");
    const nextRecord = document.getElementById("recordsNext");
    const openRecord = document.getElementById("recordsOpen");
    const dialog = document.getElementById("recordsDialog");
    const dialogImage = document.getElementById("recordsDialogImage");
    const dialogTitle = document.getElementById("recordsDialogTitle");
    const dialogArtist = document.getElementById("recordsDialogArtist");
    const dialogKicker = document.getElementById("recordsDialogKicker");
    const dialogMeta = document.getElementById("recordsDialogMeta");
    const dialogYoutube = document.getElementById("recordsDialogYoutube");
    const dialogAttribution = document.getElementById("recordsDialogAttribution");
    const dialogPrev = document.getElementById("recordsDialogPrev");
    const dialogNext = document.getElementById("recordsDialogNext");
    const closeDialog = document.getElementById("recordsCloseDialog");

    let active = 0;
    let dragStartX = 0;
    let dragStartActive = 0;
    let dragging = false;
    let didDrag = false;

    function clamp(value, min, max) {
      return Math.min(max, Math.max(min, value));
    }

    function wrapIndex(value) {
      return ((value % records.length) + records.length) % records.length;
    }

    function nearestIndex() {
      return wrapIndex(Math.round(active));
    }

    function circularOffset(index) {
      let offset = index - active;
      const half = records.length / 2;
      while (offset > half) offset -= records.length;
      while (offset < -half) offset += records.length;
      return offset;
    }

    function nearestActiveValueFor(index) {
      const cycle = Math.round((active - index) / records.length);
      const candidates = [
        index + (cycle - 1) * records.length,
        index + cycle * records.length,
        index + (cycle + 1) * records.length
      ];
      return candidates.reduce((nearest, candidate) => (
        Math.abs(candidate - active) < Math.abs(nearest - active) ? candidate : nearest
      ));
    }

    function metaMarkup(record) {
      return `
        <div class="records-meta-row"><dt>year</dt><dd>${record.year}</dd></div>
        <div class="records-meta-row"><dt>label</dt><dd>${record.label}</dd></div>
        <div class="records-meta-row"><dt>format</dt><dd>${record.format}</dd></div>
        <div class="records-meta-row"><dt>style</dt><dd>${record.style}</dd></div>
        <div class="records-meta-row"><dt>artwork</dt><dd>${record.coverCredit}</dd></div>
      `;
    }

    function youtubeMarkup(record) {
      return `
        <div class="records-youtube-label">youtube</div>
        <a class="records-youtube-card" href="https://www.youtube.com/watch?v=${record.youtubeId}" target="_blank" rel="noopener" aria-label="open ${record.youtubeTitle} on youtube">
          <img src="https://i.ytimg.com/vi/${record.youtubeId}/hqdefault.jpg" alt="">
          <span class="records-youtube-play" aria-hidden="true"><span>▶</span></span>
        </a>
        <a class="records-youtube-title" href="https://www.youtube.com/watch?v=${record.youtubeId}" target="_blank" rel="noopener">${record.youtubeTitle}</a>
      `;
    }

    function updateInfo() {
      const index = nearestIndex();
      const record = records[index];
      counter.textContent = `${index + 1} / ${records.length}`;
      currentTitle.textContent = record.title;
      currentArtist.textContent = record.artist;
      currentYoutube.innerHTML = youtubeMarkup(record);
      currentMeta.innerHTML = metaMarkup(record);
    }

    function renderStack() {
      const front = nearestIndex();
      document.querySelectorAll(".records-record").forEach((button, index) => {
        const offset = circularOffset(index);
        const depth = Math.abs(offset);
        const isFront = index === front;
        const x = offset * 132 - 160 + (offset > 0 ? 28 : 0);
        const y = depth * 17 + (isFront ? -22 : 0);
        const rotate = offset * -5.8 + (index % 2 ? 1.4 : -1.8);
        const scale = clamp(1 - depth * 0.045, 0.78, 1.04);
        const z = 60 - Math.round(depth * 5) + (offset > 0 ? 1 : 0);
        const opacity = depth > 4 ? 0 : clamp(1 - depth * 0.12, 0.42, 1);
        button.classList.toggle("is-front", isFront);
        button.style.zIndex = String(z);
        button.style.opacity = String(opacity);
        button.style.filter = `saturate(${clamp(1.05 - depth * 0.04, 0.78, 1.05)}) brightness(${clamp(1 - depth * 0.07, 0.66, 1)})`;
        button.style.transform = `translateX(calc(-50% + ${x}px)) translateY(${y}px) rotateY(${offset * -7}deg) rotateZ(${rotate}deg) scale(${scale})`;
      });
      updateInfo();
    }

    function setActive(value, snap = true) {
      active = snap ? Math.round(value) : value;
      renderStack();
    }

    function setActiveIndex(index) {
      setActive(nearestActiveValueFor(index));
    }

    function openFocused(index = nearestIndex()) {
      const record = records[index];
      dialogImage.src = record.cover;
      dialogImage.alt = `${record.title} cover art`;
      dialogTitle.textContent = record.title;
      dialogArtist.textContent = record.artist;
      dialogKicker.textContent = `selection ${index + 1} of ${records.length}`;
      dialogMeta.innerHTML = metaMarkup(record);
      dialogYoutube.innerHTML = youtubeMarkup(record);
      dialogAttribution.innerHTML = `<a href="${record.discogs}" target="_blank" rel="noopener">data provided by Discogs</a>. sleeve image: ${record.coverCredit}.`;
      if (!dialog.open) dialog.showModal();
    }

    function recordIndexFromPoint(clientX, clientY) {
      const candidates = Array.from(document.querySelectorAll(".records-record"))
        .map((button, index) => {
          const rect = button.getBoundingClientRect();
          const contains = clientX >= rect.left && clientX <= rect.right && clientY >= rect.top && clientY <= rect.bottom;
          if (!contains) return null;
          const centerX = rect.left + rect.width / 2;
          const centerY = rect.top + rect.height / 2;
          const distance = Math.hypot(clientX - centerX, clientY - centerY);
          const zIndex = Number(window.getComputedStyle(button).zIndex) || 0;
          return { index, distance, zIndex };
        })
        .filter(Boolean);

      if (!candidates.length) return null;
      candidates.sort((a, b) => b.zIndex - a.zIndex || a.distance - b.distance);
      return candidates[0].index;
    }

    records.forEach((record, index) => {
      const button = document.createElement("button");
      button.className = "records-record";
      button.type = "button";
      button.setAttribute("aria-label", `${record.artist}, ${record.title}`);
      button.innerHTML = `
        <img src="${record.cover}" alt="${record.title} cover art" loading="${index === 0 ? "eager" : "lazy"}">
        <span class="records-spine"></span>
        <span class="records-sleeve-label"><span>${record.artist}</span><span>${record.year}</span></span>
      `;
      stack.appendChild(button);
    });

    stage.addEventListener("pointerdown", (event) => {
      dragging = true;
      didDrag = false;
      dragStartX = event.clientX;
      dragStartActive = active;
      stage.classList.add("is-dragging");
      stage.setPointerCapture(event.pointerId);
    });

    stage.addEventListener("pointermove", (event) => {
      if (!dragging) return;
      if (Math.abs(event.clientX - dragStartX) > 6) didDrag = true;
      const delta = (event.clientX - dragStartX) / 150;
      setActive(dragStartActive - delta, false);
    });

    function endDrag(event) {
      if (!dragging) return;
      dragging = false;
      stage.classList.remove("is-dragging");
      if (stage.hasPointerCapture(event.pointerId)) stage.releasePointerCapture(event.pointerId);
      setActive(active, true);
    }

    stage.addEventListener("pointerup", endDrag);
    stage.addEventListener("pointercancel", endDrag);

    stage.addEventListener("click", (event) => {
      if (didDrag) return;
      const clickedIndex = recordIndexFromPoint(event.clientX, event.clientY);
      if (clickedIndex === null) return;
      setActiveIndex(clickedIndex);
    });

    stage.addEventListener("wheel", (event) => {
      event.preventDefault();
      setActive(active + event.deltaY / 420, false);
      window.clearTimeout(stage.wheelTimer);
      stage.wheelTimer = window.setTimeout(() => setActive(active, true), 90);
    }, { passive: false });

    document.addEventListener("keydown", (event) => {
      if (event.key === "ArrowRight") {
        setActive(active + 1);
        if (dialog.open) openFocused(nearestIndex());
      }
      if (event.key === "ArrowLeft") {
        setActive(active - 1);
        if (dialog.open) openFocused(nearestIndex());
      }
      if (event.key === "Enter" && !dialog.open) {
        openFocused();
      }
      if (event.key === "Escape" && dialog.open) {
        dialog.close();
      }
    });

    prevRecord.addEventListener("click", () => setActive(active - 1));
    nextRecord.addEventListener("click", () => setActive(active + 1));
    openRecord.addEventListener("click", () => openFocused());
    dialogPrev.addEventListener("click", () => {
      setActive(active - 1);
      openFocused(nearestIndex());
    });
    dialogNext.addEventListener("click", () => {
      setActive(active + 1);
      openFocused(nearestIndex());
    });
    closeDialog.addEventListener("click", () => dialog.close());
    dialog.addEventListener("click", (event) => {
      const rect = dialog.getBoundingClientRect();
      const outside = event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom;
      if (outside) dialog.close();
    });
    dialog.addEventListener("close", () => {
      dialogYoutube.innerHTML = "";
    });

    renderStack();
  })();
</script>

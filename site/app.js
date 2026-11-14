(() => {
  const LABELS = {
    all: "All", explosion: "Explosion", slash: "Slash", impact: "Impact", aura: "Aura", beam: "Beam",
    projectile: "Projectile", lightning: "Lightning", fire: "Fire", icewater: "Ice & water",
    darkportal: "Dark & portal", misc: "Holy & other",
  };
  const grid = document.getElementById("grid");
  const chips = document.getElementById("chips");
  const recipeGrid = document.getElementById("recipe-grid");
  const box = document.getElementById("lightbox");
  const boxImg = box.querySelector("img");
  const boxCap = box.querySelector("figcaption");
  let lastFocus = null;

  // copy buttons
  document.querySelectorAll("[data-copy]").forEach((b) => {
    b.addEventListener("click", async () => {
      try { await navigator.clipboard.writeText(b.dataset.copy); b.textContent = "copied"; }
      catch { b.textContent = "select it"; }
      setTimeout(() => (b.textContent = "copy"), 1500);
    });
  });

  function openBox(src, caption, from) {
    lastFocus = from;
    boxImg.src = src;
    boxImg.alt = caption;
    boxCap.innerHTML = caption;
    box.hidden = false;
    box.querySelector(".close").focus();
  }
  function closeBox() {
    box.hidden = true;
    boxImg.src = "";
    if (lastFocus) lastFocus.focus();
  }
  box.addEventListener("click", (e) => { if (e.target === box || e.target.classList.contains("close")) closeBox(); });
  document.addEventListener("keydown", (e) => { if (e.key === "Escape" && !box.hidden) closeBox(); });

  function card(src, thumb, title, sub, tag, caption, extraClass) {
    const b = document.createElement("button");
    b.className = "card" + (extraClass ? " " + extraClass : "");
    b.type = "button";
    const t = document.createElement("div");
    t.className = "thumb";
    t.style.backgroundImage = `url("${thumb}")`;
    t.setAttribute("role", "img");
    t.setAttribute("aria-label", title);
    const m = document.createElement("div");
    m.className = "meta";
    m.innerHTML = `<b>${title}</b><span>${tag ? `<span class="tag">${tag}</span>` : ""}${sub}</span>`;
    b.append(t, m);
    b.addEventListener("click", () => openBox(src, caption, b));
    return b;
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c])); }

  (window.VFXMITH ? Promise.resolve(window.VFXMITH) : fetch("site/effects.json").then((r) => r.json())).then((data) => {
    const effects = data.effects;
    const cats = ["all", ...Object.keys(LABELS).filter((k) => k !== "all" && effects.some((e) => e.category === k))];
    let current = "all";
    function render() {
      grid.replaceChildren(...effects
        .filter((e) => current === "all" || e.category === current)
        .map((e) => {
          const sub = `${e.layers ?? "?"} layers${e.length ? ` · ~${e.length} s` : ""}`;
          const repo = "https://github.com/Frxctured/roblox-vfxmith/blob/main/";
          const cap = `<b>${esc(e.title)}</b> · ${esc(e.file)}${e.card ? ` · <a href="${repo}${e.card}">layer values</a>` : ""}`;
          return card(e.sheet, e.thumb || e.sheet, esc(e.title), sub, LABELS[e.category] || e.category, cap);
        }));
    }
    cats.forEach((c) => {
      const b = document.createElement("button");
      b.type = "button";
      b.setAttribute("role", "tab");
      const n = c === "all" ? effects.length : effects.filter((e) => e.category === c).length;
      b.textContent = `${LABELS[c]} ${n}`;
      b.setAttribute("aria-selected", String(c === current));
      b.addEventListener("click", () => {
        current = c;
        chips.querySelectorAll("button").forEach((x) => x.setAttribute("aria-selected", String(x === b)));
        render();
      });
      chips.append(b);
    });
    render();
    data.recipes.forEach((r) => {
      const type = r.replace("_recipe", "");
      recipeGrid.append(card(`gallery/recipes/${r}.jpg`, `site/thumbs/${r}.jpg`, LABELS[type] || type, `${r}.luau`, "recipe",
        `<b>${esc(LABELS[type] || type)} recipe</b> · knowledge/categories/${esc(r)}.luau, played in Studio`, ""));
    });
    document.querySelectorAll("[data-count]").forEach((el) => {
      const v = data.counts[el.dataset.count];
      if (v) el.textContent = v.toLocaleString("en-US");
    });
  }).catch(() => {
    grid.innerHTML = '<p class="note">The gallery data could not be loaded. Browse <a href="https://github.com/Frxctured/roblox-vfxmith/tree/main/gallery">gallery/</a> on GitHub instead.</p>';
  });
})();

// State
let currentGenre = "All";
let searchQuery = "";

// DOM Elements
const gamesGrid = document.getElementById("games-grid");
const searchInput = document.getElementById("search-input");
const searchBtn = document.getElementById("search-btn");
const gameCountText = document.getElementById("game-count");

// Modal Elements
const gameModal = document.getElementById("game-modal");
const modalBanner = document.getElementById("modal-banner");
const modalGenre = document.getElementById("modal-genre");
const modalTitle = document.getElementById("modal-title");
const modalRating = document.getElementById("modal-rating");
const modalPlayers = document.getElementById("modal-players");
const modalDescription = document.getElementById("modal-description");
const modalFeatures = document.getElementById("modal-features");
const btnPlayPopup = document.getElementById("btn-play-popup");
const btnPlayTab = document.getElementById("btn-play-tab");

// Initialize Lucide Icons on load
document.addEventListener("DOMContentLoaded", () => {
  if (window.lucide) {
    window.lucide.createIcons();
  }
  renderGames();
});

// Real-time Search Input Handler
searchInput.addEventListener("input", (e) => {
  searchQuery = e.target.value.toLowerCase().trim();
  renderGames();
});

// Filter by genre
function filterGenre(genre) {
  currentGenre = genre;

  // Update Tab buttons styles
  const tabs = document.querySelectorAll(".genre-tab");
  tabs.forEach(tab => {
    if (tab.getAttribute("data-genre") === genre) {
      tab.classList.add("bg-cyan-500/10", "text-cyan-400", "border-cyan-500/30", "shadow-[0_0_10px_rgba(0,240,255,0.15)]");
    } else {
      tab.classList.remove("bg-cyan-500/10", "text-cyan-400", "border-cyan-500/30", "shadow-[0_0_10px_rgba(0,240,255,0.15)]");
    }
  });

  renderGames();
}

// Reset filters back to default
function resetFilters() {
  searchInput.value = "";
  searchQuery = "";
  filterGenre("All");
}

// Render Games Grid
function renderGames() {
  // Clear Grid
  gamesGrid.innerHTML = "";

  // Filter games based on genre and search query
  const filteredGames = gamesData.filter(game => {
    const matchesGenre = (currentGenre === "All" || game.genre === currentGenre);
    const matchesSearch = (game.title.toLowerCase().includes(searchQuery) || game.description.toLowerCase().includes(searchQuery));
    return matchesGenre && matchesSearch;
  });

  // Update count text
  gameCountText.textContent = `Menampilkan ${filteredGames.length} Game`;

  if (filteredGames.length === 0) {
    gamesGrid.innerHTML = `
      <div class="col-span-full py-16 flex flex-col items-center justify-center text-center">
        <div class="w-16 h-16 rounded-full bg-red-500/10 flex items-center justify-center border border-red-500/20 text-red-400 mb-4 animate-bounce">
          <i data-lucide="frown" class="w-8 h-8"></i>
        </div>
        <p class="text-lg font-bold text-gray-300">Game tidak ditemukan</p>
        <p class="text-sm text-gray-500 mt-1">Coba gunakan kata kunci pencarian atau genre lain.</p>
      </div>
    `;
    if (window.lucide) window.lucide.createIcons();
    return;
  }

  // Generate game cards
  filteredGames.forEach(game => {
    const card = document.createElement("div");
    card.className = "glass-card rounded-2xl overflow-hidden cursor-pointer flex flex-col group h-full";
    card.setAttribute("onclick", `openGameDetails("${game.id}")`);

    card.innerHTML = `
      <!-- Thumbnail with Overlay -->
      <div class="relative h-48 w-full overflow-hidden">
        <img src="${game.image}" alt="${game.title}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
        <div class="absolute inset-0 bg-gradient-to-t from-[#0a0a16] to-transparent opacity-60"></div>
        <div class="absolute bottom-3 left-3 z-10 flex items-center gap-1.5">
          <span class="bg-black/60 backdrop-blur px-2.5 py-1 rounded text-xs font-mono text-cyan-400 border border-cyan-400/20">${game.genre}</span>
        </div>
        <div class="absolute top-3 right-3 z-10 bg-black/60 backdrop-blur px-2.5 py-1 rounded-full text-xs font-semibold text-yellow-400 flex items-center gap-1 border border-yellow-400/20">
          <i data-lucide="star" class="w-3.5 h-3.5 fill-yellow-400"></i> ${game.rating}
        </div>
      </div>

      <!-- Content -->
      <div class="p-6 flex-grow flex flex-col justify-between">
        <div>
          <h3 class="text-lg font-bold mb-2 group-hover:text-cyan-400 transition-colors line-clamp-1">${game.title}</h3>
          <p class="text-gray-400 text-xs leading-relaxed line-clamp-2 mb-4">${game.description}</p>
        </div>

        <div class="flex items-center justify-between pt-4 border-t border-gray-900 mt-auto">
          <div class="text-[11px] font-mono text-gray-500">
            <span class="text-cyan-400">${game.players}</span> PLAYING
          </div>
          <span class="text-xs font-bold text-cyan-400 group-hover:text-cyan-300 flex items-center gap-1 transition-all">
            Play Game <i data-lucide="chevron-right" class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform"></i>
          </span>
        </div>
      </div>
    `;

    gamesGrid.appendChild(card);
  });

  if (window.lucide) {
    window.lucide.createIcons();
  }
}

// Open Game Details in Modal
function openGameDetails(gameId) {
  const game = gamesData.find(g => g.id === gameId);
  if (!game) return;

  // Set modal elements
  modalBanner.src = game.banner;
  modalGenre.textContent = game.genre;
  modalTitle.textContent = game.title;
  modalRating.textContent = game.rating.toFixed(1);
  modalPlayers.textContent = game.players;
  modalDescription.textContent = game.description;

  // Build features list
  modalFeatures.innerHTML = "";
  game.features.forEach(feat => {
    const li = document.createElement("li");
    li.className = "flex items-start gap-2 text-xs text-gray-400";
    li.innerHTML = `
      <i data-lucide="check-circle" class="w-4 h-4 text-cyan-400 shrink-0 mt-0.5"></i>
      <span>${feat}</span>
    `;
    modalFeatures.appendChild(li);
  });

  if (window.lucide) {
    window.lucide.createIcons();
  }

  // Setup Launcher Actions
  // Method 1: Standalone Popup Window (Locks size, hides menus, bypassed iframe defense!)
  btnPlayPopup.onclick = () => {
    const width = 1100;
    const height = 750;
    const left = (screen.width - width) / 2;
    const top = (screen.height - height) / 2;

    // Popup options to make it look like a standalone application window
    const options = `width=${width},height=${height},top=${top},left=${left},menubar=no,toolbar=no,location=no,status=no,resizable=yes,scrollbars=yes`;
    window.open(game.url, `G123_Standalone_${game.id}`, options);
    closeModal();
  };

  // Method 2: Normal Tab Mode
  btnPlayTab.onclick = () => {
    window.open(game.url, "_blank");
    closeModal();
  };

  // Show Modal
  gameModal.classList.remove("hidden");
  setTimeout(() => {
    gameModal.classList.remove("opacity-0");
  }, 10);
}

// Close Modal
function closeModal() {
  gameModal.classList.add("opacity-0");
  setTimeout(() => {
    gameModal.classList.add("hidden");
  }, 300);
}

// Close Modal on clicking outside
gameModal.addEventListener("click", (e) => {
  if (e.target === gameModal) {
    closeModal();
  }
});

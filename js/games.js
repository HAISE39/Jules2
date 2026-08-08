const gamesData = [
  {
    id: "goblin-slayer",
    title: "Goblin Slayer: Endless Hunting",
    genre: "RPG",
    rating: 4.8,
    players: "120K+",
    url: "https://h5.g123.jp/game/goblinslayer?lang=en",
    image: "https://platform-ik.g123.jp/admin/2022/9/1663046486611.png",
    banner: "https://platform-ik.g123.jp/admin/2022/9/1663047679278.png",
    description: "Pertarungan epik tanpa akhir melawan pasukan Goblin! Berdasarkan anime populer Goblin Slayer, pimpin petualang Anda, tingkatkan perlengkapan, dan selamatkan dunia dari kehancuran.",
    features: [
      "Sistem pertempuran otomatis yang adiktif",
      "Karakter asli anime dengan pengisi suara terkenal",
      "Sistem guild dan pertempuran boss kooperatif",
      "Pilihan kelas dan kustomisasi senjata legendaris"
    ]
  },
  {
    id: "queens-blade",
    title: "Queen's Blade Limit Break",
    genre: "RPG",
    rating: 4.7,
    players: "95K+",
    url: "https://h5.g123.jp/game/queensblade?lang=en",
    image: "https://platform-ik.g123.jp/admin/2021/12/1639979135018.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1728609325018.jpg",
    description: "Kumpulkan para prajurit cantik dari waralaba Queen's Blade legendaris! Susun formasi terbaik Anda, aktifkan sinergi skill, dan tantang batas Anda dalam petualangan RPG strategis yang mendebarkan.",
    features: [
      "Animasi karakter Live2D yang sangat halus",
      "Lebih dari 50 prajurit wanita cantik untuk dikoleksi",
      "Sistem pertempuran taktis yang mendalam",
      "Buka kostum premium eksklusif"
    ]
  },
  {
    id: "peter-grill",
    title: "Peter Grill and the Philosopher's Time: Defender",
    genre: "Strategy",
    rating: 4.5,
    players: "80K+",
    url: "https://h5.g123.jp/game/peter?lang=en",
    image: "https://g123.jp/news/calendar-date-range.svg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820555697.jpg",
    description: "Pria terkuat di dunia, Peter Grill, harus mempertahankan kehormatan dan benihnya dari godaan para gadis monster yang haus kekuasaan dalam game Tower Defense RPG strategis yang kocak ini!",
    features: [
      "Gameplay Tower Defense yang menantang dan adiktif",
      "Gadis monster dengan keahlian unik",
      "Cerita humoris yang diadaptasi dari serial anime",
      "Upgrade markas pertahanan kustomisasi taktis"
    ]
  },
  {
    id: "seirei-gensouki",
    title: "Seirei Gensouki: Spirit Chronicles - Another Tale",
    genre: "RPG",
    rating: 4.6,
    players: "110K+",
    url: "https://h5.g123.jp/game/seirei?lang=en",
    image: "https://platform-ik.g123.jp/admin/2021/12/1639979135018.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1728551410262.jpg",
    description: "Rasakan petualangan fantasi luar biasa bersama Rio di dunia lain! Kumpulkan sekutu-sekutu kuat, atur formasi pertempuran taktikal Anda, dan taklukkan naga legendaris.",
    features: [
      "Pengisi suara asli anime legendaris",
      "Petualangan Isekai RPG fantasi spektakuler",
      "Pertempuran kooperatif Raid Boss multipemain",
      "Auto-battle yang memudahkan grinding harian"
    ]
  },
  {
    id: "so-im-a-spider",
    title: "So I'm a Spider, So What? Labyrinth",
    genre: "RPG",
    rating: 4.9,
    players: "145K+",
    url: "https://h5.g123.jp/game/kumo?lang=en",
    image: "https://platform-ik.g123.jp/admin/2022/9/1663046486611.png",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1728609325018.jpg",
    description: "Bantu Kumoko bertahan hidup dan mengeksplorasi labirin Elroe yang mematikan! Gunakan taktik jaring laba-laba unik untuk mengalahkan monster tangguh demi terus berevolusi.",
    features: [
      "Sistem evolusi monster yang sangat kompleks",
      "Elemen taktis pertahanan jaring laba-laba",
      "Animasi imut yang terinspirasi langsung dari anime",
      "Kumpulkan berbagai skill cheat yang kuat"
    ]
  },
  {
    id: "arifureta",
    title: "Arifureta: From Commonplace to World's Strongest - Rebellion Soul",
    genre: "RPG",
    rating: 4.7,
    players: "130K+",
    url: "https://h5.g123.jp/game/arifure?lang=en",
    image: "https://platform-ik.g123.jp/admin/2024/10/1729820501430.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820508963.jpg",
    description: "Ikuti kisah Hajime Nagumo yang berjuang dari titik terendah hingga menjadi sinergis terkuat di dunia! Transmutasikan berbagai artefak legendaris dan hadapi dungeon berbahaya bersama para gadis harem impian.",
    features: [
      "Visual ilustrasi eksklusif premium yang sangat artistik",
      "Sistem pembuatan & transmutasi artefak tempur",
      "Alur petualangan isekai fantasi yang mendalam",
      "Pertarungan tim dengan kombo elemen tak terbatas"
    ]
  },
  {
    id: "isesuma",
    title: "In Another World with My Smartphone: Fantasia Connect",
    genre: "RPG",
    rating: 4.8,
    players: "115K+",
    url: "https://h5.g123.jp/game/isesuma?lang=en",
    image: "https://platform-ik.g123.jp/admin/2021/12/1639979135018.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1728551410262.jpg",
    description: "Nikmati petualangan seru di dunia lain bersama sembilan gadis kandidat istrimu dan smartphone andalanmu! Jelajahi berbagai kerajaan, selesaikan quest serikat, dan hadapi ancaman kuno.",
    features: [
      "Kumpulkan dan latih lebih dari 30 karakter anime",
      "Petualangan Isekai penuh romansa dan humor mendalam",
      "Otomatisasi pertempuran idle yang praktis",
      "Kustomisasi Touya dengan gear, skin, dan sihir unik"
    ]
  },
  {
    id: "hotd",
    title: "High School of the Dead: Day 0",
    genre: "Strategy",
    rating: 4.6,
    players: "90K+",
    url: "https://h5.g123.jp/game/hotd?lang=en",
    image: "https://platform-ik.g123.jp/admin/2022/9/1663046486611.png",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820508963.jpg",
    description: "Bertahan hidup dari kiamat zombie bersama Takashi dan kawan-kawan! Bangun benteng pertahanan terkuat, kumpulkan perbekalan, dan hancurkan setiap mayat hidup yang menghalangi.",
    features: [
      "Gameplay tower defense bertahan hidup yang menegangkan",
      "Sistem upgrade benteng dan senjata modern",
      "Karakter utama orisinal dari anime HOTD",
      "Tantangan misi harian bertahan dari gelombang zombie"
    ]
  },
  {
    id: "ryoran",
    title: "Hyakka Ryoran Master Samurai Chronicles",
    genre: "RPG",
    rating: 4.7,
    players: "105K+",
    url: "https://h5.g123.jp/game/ryoran?lang=en",
    image: "https://platform-ik.g123.jp/admin/2021/12/1639979135018.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1728609325018.jpg",
    description: "Ikuti kisah Muneakira Yagyu di Akademi Buou bersama para Master Samurai cantik! Latih dan tingkatkan kemampuan para samurai wanita tangguh demi memenangkan perang legendaris.",
    features: [
      "Kumpulkan dan latih lebih dari 20 Master Samurai cantik",
      "Pertarungan idle RPG yang cepat dan penuh aksi spektakuler",
      "Hubungan romantis dan kedekatan khusus dengan samurai",
      "Upgrade senjata legendaris dan perlengkapan khusus"
    ]
  },
  {
    id: "kakegurui",
    title: "Kakegurui ALL IN",
    genre: "Strategy",
    rating: 4.8,
    players: "140K+",
    url: "https://h5.g123.jp/game/kakegurui?lang=en",
    image: "https://platform-ik.g123.jp/admin/2024/10/1729820501430.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820508963.jpg",
    description: "Masuki Akademi Swasta Hyakkaou dan pertaruhkan segalanya dalam game taktis psikologis paling menegangkan bersama Yumeko Jabami!",
    features: [
      "Pertarungan kartu strategi psikologis orisinal",
      "Karakter anime Kakegurui bersuara asli lengkap",
      "Turnamen peringkat kompetitif multipemain online",
      "Animasi kemenangan yang luar biasa dramatis"
    ]
  },
  {
    id: "highschool",
    title: "High School DxD Operation Paradise Infinity",
    genre: "RPG",
    rating: 4.9,
    players: "160K+",
    url: "https://h5.g123.jp/game/highschool?lang=en",
    image: "https://platform-ik.g123.jp/admin/2024/10/1729820501430.jpg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820508963.jpg",
    description: "Bangun faksi iblis harem terkuat bersama Issei, Rias Gremory, dan Akeno! Manfaatkan sinergi skill istimewa untuk menguasai turnamen Tiga Kubu.",
    features: [
      "Lebih dari 60 karakter iblis seksi untuk direkrut",
      "Karya seni galeri premium eksklusif dalam game",
      "Interaksi kencan intensif untuk menaikkan kekuatan",
      "Event kolaborasi musiman yang spektakuler"
    ]
  },
  {
    id: "kusuriya",
    title: "The Apothecary Diaries Palace Chronicles",
    genre: "Puzzle",
    rating: 4.7,
    players: "125K+",
    url: "https://h5.g123.jp/game/kusuriya?lang=en",
    image: "https://g123.jp/news/calendar-date-range.svg",
    banner: "https://platform-ik.g123.jp/admin/2024/10/1729820555697.jpg",
    description: "Pecahkan setiap misteri racun dan intrik istana kekaisaran bersama Maomao dan Jinshi dalam petualangan visual teka-teki logika yang sangat menawan!",
    features: [
      "Teka-teki penyusunan ramuan obat istana dalam",
      "Cerita visual novel penuh misteri dan ketegangan",
      "Interaksi manis nan jenaka antara Maomao dan Jinshi",
      "Buka ilustrasi bab cerita premium khusus"
    ]
  }
];
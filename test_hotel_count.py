import os

areas = {
    'Malioboro': [
        ('htl-malio-1', 'Grand Malioboro Heritage Hotel', 'Jl. Malioboro No. 60, Danurejan, Kota Yogyakarta', -7.7928, 110.3658, 4.8, 2890, 4, 520000, 'Best Value', 'Hotel bersejarah tepat di jantung Malioboro, 3 menit jalan kaki ke Stasiun Tugu.'),
        ('htl-malio-2', 'Ibis Styles Yogyakarta Malioboro', 'Jl. Dagen No. 109, Sosromenduran, Gedong Tengen, Kota Yogyakarta', -7.7915, 110.3642, 4.6, 1750, 3, 430000, 'Popular', 'Hotel modern ceria dengan rooftop pool dan bar pemandangan kota dekat Malioboro.'),
        ('htl-malio-3', 'Melia Purosani Yogyakarta', 'Jl. Mayor Suryotomo No. 31, Ngupasan, Gondomanan, Kota Yogyakarta', -7.7989, 110.3705, 4.8, 3120, 5, 880000, 'Luxury 5★', 'Resort oasis tropis bintang 5 di pusat kota dengan taman hijau rimbun dan spa Yhi.'),
        ('htl-malio-4', 'Novotel Suites Yogyakarta Malioboro', 'Jl. Malioboro No. 52-58, Malioboro Mall, Kota Yogyakarta', -7.7910, 110.3662, 4.8, 1980, 4, 760000, 'Top Rated', 'Terhubung langsung dengan Malioboro Mall dengan fasilitas suite modern dan dapur mini.'),
        ('htl-malio-5', 'Harper Malioboro Yogyakarta', 'Jl. P. Mangkubumi No. 52, Gowongan, Jetis, Kota Yogyakarta', -7.7850, 110.3670, 4.7, 2410, 4, 590000, 'Best Value', 'Hotel bernuansa rustik modern dekat Tugu Jogja dan Malioboro, terkenal dengan Rustik Bistro.'),
        ('htl-malio-6', 'Whiz Hotel Malioboro Yogyakarta', 'Jl. Dagen No. 8, Sosromenduran, Gedong Tengen, Kota Yogyakarta', -7.7920, 110.3650, 4.5, 1420, 3, 310000, 'Budget Choice', 'Hotel simpel, bersih, dan super strategis di gang Dagen untuk pelancong hemat.'),
    ],
    'Prawirotaman': [
        ('htl-prawiro-1', 'Greenhost Boutique Hotel Prawirotaman', 'Jl. Gerilya Prawirotaman II No. 629, Mergangsan, Kota Yogyakarta', -7.8188, 110.3695, 4.7, 1850, 4, 460000, 'Eco-Art Hotel', 'Hotel butik ramah lingkungan dengan kebun hidroponik vertikal dan kolam renang tropis.'),
        ('htl-prawiro-2', 'Adhisthana Hotel Prawirotaman', 'Jl. Prawirotaman II No. 613, Brontokusuman, Mergangsan, Kota Yogyakarta', -7.8192, 110.3702, 4.8, 2210, 3, 390000, 'Top Aesthetic', 'Hotel bergaya arsitektur jendela antik dan dekorasi vintage Jogja nan Instagrammable.'),
        ('htl-prawiro-3', 'ViaVia Guesthouse & Artisan Cafe', 'Jl. Prawirotaman No. 30, Mergangsan, Kota Yogyakarta', -7.8175, 110.3688, 4.6, 940, 3, 320000, 'Backpacker Fav', 'Guesthouse ramah wisatawan mancanegara dengan roti artisan organik dan tur lokal.'),
        ('htl-prawiro-4', 'Gallery Prawirotaman Hotel', 'Jl. Prawirotaman II No. 839, Mergangsan, Kota Yogyakarta', -7.8198, 110.3715, 4.7, 1630, 4, 550000, 'Art Gallery', 'Hotel mewah bertema galeri lukisan kontemporer dengan kolam renang luas dan pemandangan kota.'),
        ('htl-prawiro-5', 'D\'Omah Boutique Prawirotaman', 'Jl. Prawirotaman I No. 12, Mergangsan, Kota Yogyakarta', -7.8170, 110.3680, 4.7, 720, 4, 620000, 'Authentic Javanese', 'Villa peninggalan Jawa klasik dengan halaman asri dan sentuhan ukiran antik.'),
        ('htl-prawiro-6', 'Por Aqui Stay & Dine Prawirotaman', 'Jl. Prawirotaman No. 31, Mergangsan, Kota Yogyakarta', -7.8180, 110.3690, 4.8, 1340, 3, 480000, 'Bohemian Vibe', 'Penginapan unik bertema Meksiko bohemian pertama di Jogja dengan kolam renang warna-warni.'),
    ],
    'Kraton': [
        ('htl-kraton-1', 'The Phoenix Heritage Hotel MGallery', 'Jl. Jend. Sudirman No. 9, Jetis, Kota Yogyakarta', -7.7828, 110.3672, 4.8, 1450, 5, 680000, 'Member Exclusive', 'Hotel kolonial bintang 5 bergaya Eropa-Jawa klasik dekat Tugu dan Kraton.'),
        ('htl-kraton-2', 'Royal Ambarrukmo Heritage Palace', 'Jl. Laksda Adisucipto No. 81, Caturtunggal, Kota Yogyakarta', -7.7820, 110.4005, 4.9, 3890, 5, 950000, 'Royal Palace', 'Hotel istana megah bekas kediaman Sultan HB VII dengan museum peninggalan kerajaan.'),
        ('htl-kraton-3', 'Puri Pangeran Heritage Hotel', 'Jl. MG II No. 371, Mergangsan (Dekat Kraton), Kota Yogyakarta', -7.8080, 110.3720, 4.5, 610, 3, 330000, 'Classic Javanese', 'Penginapan tenang dengan arsitektur limasan Jawa dan kebun bunga tropis asri.'),
        ('htl-kraton-4', 'NDalem Kilen Kraton Guesthouse', 'Jl. Magangan Kulon No. 4, Patehan, Kraton, Kota Yogyakarta', -7.8075, 110.3615, 4.7, 480, 3, 310000, 'Kraton Inside', 'Guesthouse otentik tepat di dalam benteng Kraton Jogja dengan nuansa ningrat.'),
        ('htl-kraton-5', 'Griya Wijilan Heritage Inn', 'Jl. Wijilan No. 22, Panembahan, Kraton, Kota Yogyakarta', -7.8045, 110.3690, 4.6, 520, 3, 290000, 'Culinary Center', 'Penginapan tepat di sentra kuliner Gudeg Wijilan, hanya 5 menit jalan kaki ke alun-alun.'),
    ],
    'Kotagede': [
        ('htl-kota-1', 'Omah Kotagede Heritage Guesthouse', 'Jl. Mondorakan No. 45, Jagalan, Kotagede, Kota Yogyakarta', -7.8283, 110.3986, 4.6, 540, 3, 350000, 'Joglo Heritage', 'Penginapan rumah Joglo berumur ratusan tahun di tengah sentra perak Kotagede.'),
        ('htl-kota-2', 'Kalingga Heritage Kotagede', 'Jl. Karanglo No. 12, Purbayan, Kotagede, Kota Yogyakarta', -7.8290, 110.4010, 4.7, 390, 3, 380000, 'Ancient Mataram', 'Guesthouse bergaya rumah Kalang khas saudagar Kotagede zaman Mataram Islam.'),
        ('htl-kota-3', 'Omah Kalang Heritage Villa', 'Jl. Tegal Gendu No. 8, Prenggan, Kotagede, Kota Yogyakarta', -7.8270, 110.3950, 4.8, 310, 4, 580000, 'Boutique Villa', 'Villa privat mewah dengan arsitektur perpaduan Jawa, Belanda, dan art deco.'),
        ('htl-kota-4', 'Rumah Palagan Kotagede Inn', 'Jl. Tegalgendu No. 28, Kotagede, Kota Yogyakarta', -7.8265, 110.3940, 4.5, 270, 3, 290000, 'Budget Heritage', 'Penginapan ramah kantong di tepi sungai Gajahwong dekat pengrajin perak.'),
        ('htl-kota-5', 'Pondok Perak Kotagede', 'Jl. Kemasan No. 15, Kotagede, Kota Yogyakarta', -7.8295, 110.4000, 4.6, 410, 3, 320000, 'Silver Center', 'Homey guesthouse dengan galeri perak eksklusif dan sarapan jajanan kipo.'),
    ],
    'Kaliurang': [
        ('htl-kali-1', 'Griya Persada Convention Hotel & Resort', 'Jl. Boyong No. 99, Kaliurang Barat, Hargobinangun, Pakem, Sleman', -7.5975, 110.4215, 4.7, 2150, 4, 480000, 'Family Resort', 'Resort keluarga berhawa sejuk dengan kolam renang air hangat dan mini zoo.'),
        ('htl-kali-2', 'Merapi View Resort & Spa', 'Jl. Kaliurang KM 22, Hargobinangun, Pakem, Sleman', -7.5989, 110.4243, 4.9, 610, 5, 780000, 'Member Exclusive', 'Udara sejuk pegunungan dengan panorama puncak Gunung Merapi di pagi hari.'),
        ('htl-kali-3', 'Kalli Pitu Eco Resort Kaliurang', 'Jl. Astomulyo, Hargobinangun, Pakem, Sleman', -7.6010, 110.4260, 4.8, 430, 4, 650000, 'Riverside Nature', 'Glamping dan cottage tepi sungai pegunungan dengan suara gemercik air alami.'),
        ('htl-kali-4', 'Villa Pentingsari Eco Village', 'Desa Wisata Pentingsari, Umbulharjo, Cangkringan, Sleman', -7.6250, 110.4380, 4.6, 520, 3, 340000, 'Village Experience', 'Penginapan desa wisata asri dengan kegiatan membajak sawah dan gamelan.'),
        ('htl-kali-5', 'Candi Tirto Raharjo Resort Kaliurang', 'Jl. Kaliurang KM 19, Pakem, Sleman', -7.6320, 110.4200, 4.7, 380, 4, 590000, 'Serene Sanctuary', 'Resort privat asri dengan sentuhan arsitektur batu candi dan taman air meditasi.'),
        ('htl-kali-6', 'Hotel Kana Kaliurang', 'Jl. Kaliurang KM 20, Hargobinangun, Pakem, Sleman', -7.6080, 110.4230, 4.5, 680, 3, 290000, 'Mountain Escape', 'Hotel tenang berhawa dingin dikelilingi hutan pinus dengan perapian lobi.'),
    ],
    'Sleman': [
        ('htl-sleman-1', 'Hotel Tentrem Yogyakarta', 'Jl. P. Mangkubumi No. 72A, Cokrodiningratan, Jetis / Sleman', -7.7739, 110.3685, 4.9, 3420, 5, 1250000, 'Luxury 5★', 'Hotel bintang 5 ikonik dengan kolam tropis, spa Gaharu, dan fine dining.'),
        ('htl-sleman-2', 'Hyatt Regency Yogyakarta Resort & Golf', 'Jl. Palagan Tentara Pelajar, Ngaglik, Sleman', -7.7408, 110.3721, 4.9, 4120, 5, 920000, 'Top Resort', 'Resort bintang 5 seluas 22 hektar dengan golf 9-hole dan kolam bertingkat.'),
        ('htl-sleman-3', 'Eastparc Hotel Yogyakarta', 'Jl. Laksda Adisucipto KM 6.5, Seturan, Depok, Sleman', -7.7810, 110.4150, 4.9, 3650, 5, 980000, 'Best Family Hotel', 'Hotel bintang 5 ramah anak terbaik dengan mini zoo, waterpark, dan ATV.'),
        ('htl-sleman-4', 'The Alana Hotel & Convention Center', 'Jl. Palagan Tentara Pelajar KM 7, Ngaglik, Sleman', -7.7380, 110.3740, 4.7, 2840, 4, 620000, 'Business & Leisure', 'Hotel modern terhubung dengan Mataram City Convention dan kolam renang outdoor.'),
        ('htl-sleman-5', 'Indoluxe Hotel Jogja', 'Jl. Palagan Tentara Pelajar No. 106, Ngaglik, Sleman', -7.7450, 110.3730, 4.6, 2190, 4, 490000, 'Rooftop Pool', 'Hotel dengan rooftop infinity pool tertinggi di Jogja berlatar Gunung Merapi.'),
        ('htl-sleman-6', 'Sahid Raya Hotel & Convention Yogyakarta', 'Jl. Babarsari No. 2, Caturtunggal, Depok, Sleman', -7.7780, 110.4120, 4.6, 1890, 4, 440000, 'Convention Center', 'Hotel konvensi legendaris di kawasan kampus Seturan dengan kolam renang olympic.'),
    ],
    'Bantul': [
        ('htl-bantul-1', 'Queen of the South Beach Resort', 'Desa Parangrejo, Purwosari (Tebing Parangtritis), Bantul', -8.0261, 110.3344, 4.7, 1280, 4, 650000, 'Sunset Cliff', 'Resort tebing tepi laut dengan infinity pool pemandangan Samudera Hindia.'),
        ('htl-bantul-2', 'D\'Omah Yogya Hotel Kasongan', 'Jl. Kasongan No. 1, Bangunjiwo, Kasihan, Bantul', -7.8420, 110.3390, 4.8, 640, 4, 750000, 'Artisan Village', 'Resort butik mewah di tengah sentra gerabah Kasongan dengan 4 kolam renang.'),
        ('htl-bantul-3', 'Tembi Rumah Budaya Resort', 'Jl. Parangtritis KM 8.5, Sewon, Bantul', -7.8720, 110.3580, 4.7, 890, 4, 480000, 'Cultural Retreat', 'Penginapan rumah limasan di tengah sawah dengan museum kebudayaan Jawa.'),
        ('htl-bantul-4', 'Kampoeng Djowo Klaten-Bantul Resort', 'Jl. Wonosari KM 11, Piyungan, Bantul', -7.8380, 110.4560, 4.6, 420, 3, 360000, 'Nature Breeze', 'Resort alam dengan danau buatan dan nuansa pedesaan Jawa tempo dulu.'),
        ('htl-bantul-5', 'Puri Asri Parangtritis Beach Inn', 'Jl. Pantai Parangtritis, Kretek, Bantul', -8.0210, 110.3310, 4.5, 590, 3, 270000, 'Beach Access', 'Penginapan berjarak 200 meter dari pantai dengan akses mudah ke gumuk pasir.'),
        ('htl-bantul-6', 'Villa Sunset Mangunan', 'Kawasan Wisata Mangunan, Dlingo, Bantul', -7.9310, 110.4350, 4.8, 310, 4, 690000, 'Pine Forest View', 'Villa kayu privat di atas perbukitan Mangunan dengan pemandangan lembah kabut.'),
    ],
    'Gunungkidul': [
        ('htl-gk-1', 'Drini Hills Diamond Beach Resort', 'Pantai Drini, Banjarejo, Tanjungsari, Gunungkidul', -8.1384, 110.5982, 4.8, 890, 4, 580000, 'Beachfront', 'Resort villa modern di bukit Pantai Drini dengan kolam menghadap laut toska.'),
        ('htl-gk-2', 'Santorini Beach Resort Indrayanti', 'Pantai Indrayanti, Tepus, Gunungkidul', -8.1512, 110.6128, 4.7, 540, 4, 540000, 'White Sand', 'Penginapan gaya mediterania putih-biru di bibir pantai pasir putih Indrayanti.'),
        ('htl-gk-3', 'HeHa Ocean View Glamping', 'Bolang, Girikarto, Panggang, Gunungkidul', -8.0680, 110.4670, 4.8, 1780, 4, 850000, 'Ocean Glamping', 'Glamping modern mewah di tebing karang laut selatan dengan private jacuzzi.'),
        ('htl-gk-4', 'Radika Paradise Villa & Cottage Tepus', 'Jl. Pantai Krasak, Tepus, Gunungkidul', -8.1450, 110.6200, 4.6, 730, 3, 490000, 'Hilltop Seaview', 'Cottage kayu di perbukitan karang menghadap laut lepas dan hutan jati asri.'),
        ('htl-gk-5', 'Inessya Resort Baron Beach', 'Jl. Pantai Baron, Kemadang, Tanjungsari, Gunungkidul', -8.1290, 110.5480, 4.7, 450, 4, 720000, 'Infinity Ocean Pool', 'Resort privat di atas tebing Pantai Baron dengan infinity pool menatap laut.'),
        ('htl-gk-6', 'Sundak Beach House Cottage', 'Pantai Sundak, Sidoharjo, Tepus, Gunungkidul', -8.1480, 110.6080, 4.5, 380, 3, 330000, 'Cozy Beach House', 'Cottage sederhana dan asri di tepi pantai Sundak dengan sajian ikan laut bakar.'),
    ],
    'Kulon Progo': [
        ('htl-kp-1', 'Grand Dafam Signature Airport YIA', 'Jl. Nasional III KM 41.5, Temon, Kulon Progo', -7.8972, 110.0544, 4.8, 1420, 4, 510000, 'Airport Hotel', 'Hotel bintang 4 depan Bandara YIA dengan shuttle 24 jam dan rooftop pool.'),
        ('htl-kp-2', 'Swiss-Belhotel Airport Yogyakarta', 'Jl. Wates-Purworejo KM 10, Temon, Kulon Progo', -7.8950, 110.0520, 4.8, 1150, 4, 560000, 'International Standard', 'Hotel bisnis internasional terdekat ke terminal YIA dengan fasilitas lengkap.'),
        ('htl-kp-3', 'Cordia Hotel Yogyakarta Airport YIA', 'Terminal Kedatangan Bandara YIA, Temon, Kulon Progo', -7.9000, 110.0580, 4.7, 870, 3, 470000, 'Inside Terminal', 'Hotel modern langsung di dalam area terminal YIA untuk transit praktis.'),
        ('htl-kp-4', 'Ibis Yogyakarta Airport Kulon Progo', 'Jl. Bandara YIA, Palihan, Temon, Kulon Progo', -7.8920, 110.0560, 4.7, 980, 3, 420000, 'Smart Transit', 'Hotel ramah bujet berdesain kontemporer dekat stasiun kereta bandara.'),
        ('htl-kp-5', 'Menoreh Heritage Glamping & Resort', 'Perbukitan Menoreh, Girimulyo, Kulon Progo', -7.7650, 110.1500, 4.8, 340, 4, 680000, 'Mountain Cloud View', 'Glamping sejuk di ketinggian bukit Menoreh dengan panorama kebun teh dan kabut.'),
        ('htl-kp-6', 'Waduk Sermo Eco Cottage', 'Kawasan Danau Waduk Sermo, Kokap, Kulon Progo', -7.8250, 110.1200, 4.6, 420, 3, 310000, 'Lakefront Camp', 'Pondok kayu di tepi danau Waduk Sermo dengan fasilitas sewa kayak dan perahu.'),
    ],
}

print(f"Total areas: {len(areas)}")
total_hotels = sum(len(h) for h in areas.values())
print(f"Total hotels: {total_hotels}")

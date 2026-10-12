import re
from test_hotel_count import areas

# Existing hotel names in mock_data.dart
existing_names = {
    'Hotel Tentrem Yogyakarta',
    'Grand Malioboro Heritage Hotel',
    'Greenhost Boutique Hotel Prawirotaman',
    'Hyatt Regency Yogyakarta Resort & Golf',
    'Queen of the South Beach Resort',
    'Drini Hills Diamond Beach Resort',
    'Grand Dafam Signature Airport YIA',
    'Griya Persada Convention Hotel & Resort',
    'Omah Kotagede Heritage Guesthouse'
}

remaining_hotels = []
for area, hlist in areas.items():
    for h in hlist:
        if h[1] not in existing_names:
            remaining_hotels.append((area, h))

print(f"Total remaining hotels to append: {len(remaining_hotels)}")

# Hotel image pools
hotel_images_pool = [
    [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=900&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=900&auto=format&fit=crop',
    ],
    [
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=900&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=900&auto=format&fit=crop',
    ],
    [
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=900&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=900&auto=format&fit=crop',
    ],
    [
        'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=900&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=900&auto=format&fit=crop',
    ],
    [
        'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=900&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=900&auto=format&fit=crop',
    ],
]

room_images_pool = [
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
    'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
    'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
]

def generate_hotel_dart(idx_num, area, h_tuple):
    hid, name, addr, lat, lng, rating, reviews, star, price, badge, desc = h_tuple
    img_pair = hotel_images_pool[idx_num % len(hotel_images_pool)]
    
    # Facilities based on area / star
    facs = [
        'Akses WiFi Kecepatan Tinggi',
        'Parkir Gratis & Aman',
        'Restoran & Kafe Lokal',
        'Layanan Resepsionis 24 Jam',
    ]
    if star >= 4:
        facs.insert(0, 'Kolam Renang Nyaman')
        facs.append('Pusat Kebugaran / Fitness')
    if 'Beach' in name or 'Ocean' in name or area == 'Gunungkidul':
        facs.append('Pemandangan Pantai & Laut')
    elif area == 'Kaliurang':
        facs.append('Panorama Alam & Udara Sejuk')
    elif area == 'Kulon Progo' and 'Airport' in name:
        facs.append('Layanan Antar-Jemput Bandara YIA')
    elif area in ['Kraton', 'Kotagede']:
        facs.append('Dekat Kawasan Budaya & Heritage')

    # Rooms
    room1_price = price
    room1_orig = int(price * 1.25 // 10000 * 10000)
    room2_price = int(price * 1.35 // 10000 * 10000)
    room2_orig = int(room2_price * 1.25 // 10000 * 10000)

    # Clean ID for room IDs (strip 'htl-' prefix)
    clean_id = hid.replace('htl-', '')

    room1_img = room_images_pool[(idx_num * 2) % len(room_images_pool)]
    room2_img = room_images_pool[(idx_num * 2 + 1) % len(room_images_pool)]

    r1_name = "Superior Double Room" if star < 4 else "Deluxe King Room"
    r2_name = "Deluxe Twin Room" if star < 4 else "Executive Suite City View"

    # Escape quotes if any in strings
    desc_clean = desc.replace("'", "\\'")
    policy_clean = f"Check-in mulai 14:00 WIB, Check-out maksimal 12:00 WIB. Resepsionis siap melayani 24 jam."
    name_clean = name.replace("'", "\\'")
    addr_clean = addr.replace("'", "\\'")
    badge_clean = badge.replace("'", "\\'")

    dart_code = f"""    // {idx_num}. {name} ({area})
    Hotel(
      id: '{hid}',
      name: '{name_clean}',
      area: '{area}',
      address: '{addr_clean}',
      latitude: {lat},
      longitude: {lng},
      rating: {rating},
      totalReviews: {reviews},
      star: {star},
      startingPrice: {price},
      badge: '{badge_clean}',
      description:
          '{desc_clean}',
      policy: '{policy_clean}',
      images: [
        '{img_pair[0]}',
        '{img_pair[1]}',
      ],
      facilities: [
"""
    for f in facs:
        dart_code += f"        '{f.replace(\"'\", \"\\\\'\")}',\n"
    
    dart_code += f"""      ],
      rooms: [
        RoomType(
          id: 'rm-{clean_id}-1',
          hotelId: '{hid}',
          name: '{r1_name}',
          description: 'Kamar nyaman seluas 28 m² dengan fasilitas lengkap, AC sejuk, kasur empuk dan kamar mandi modern.',
          capacity: 2,
          pricePerNight: {room1_price},
          originalPrice: {room1_orig},
          stock: 4,
          cancellationPolicy: 'Gratis pembatalan s/d 24 jam sebelum check-in',
          hasBreakfast: true,
          facilities: ['1 King/Queen Bed', 'Luas 28 m²', 'Sarapan Pagi', 'AC & Smart TV', 'Free WiFi', 'Standing Shower'],
          images: ['{room1_img}'],
        ),
        RoomType(
          id: 'rm-{clean_id}-2',
          hotelId: '{hid}',
          name: '{r2_name}',
          description: 'Kamar istimewa seluas 36 m² dengan kasur premium, view menawan, sofa santai, dan perlengkapan mandi lengkap.',
          capacity: 2,
          pricePerNight: {room2_price},
          originalPrice: {room2_orig},
          stock: 2,
          cancellationPolicy: 'Gratis pembatalan s/d 24 jam sebelum check-in',
          hasBreakfast: true,
          facilities: ['Kasur King/Twin', 'Luas 36 m²', 'Balkon / Panorama View', 'Sarapan Prasmanan', 'Bathtub / Rain Shower', 'Tea & Coffee Maker'],
          images: ['{room2_img}'],
        ),
      ],
    ),
"""
    return dart_code

print("Generator function ready.")

import json

# We will define a comprehensive generator script that outputs lib/core/constants/mock_data.dart
# Ensuring:
# 1. 52 hotels:
#    - Malioboro: 6
#    - Prawirotaman: 6
#    - Kraton: 5
#    - Kotagede: 5
#    - Kaliurang: 6
#    - Sleman: 6
#    - Bantul: 6
#    - Gunungkidul: 6
#    - Kulon Progo: 6
# 2. 15 attractions
# 3. Each hotel has 2 to 3 rooms with full details:
#    (name, description, sqm, bed size, cancellation policy, breakfast, facilities, real IDR pricing, stock)
# 4. First hotel id includes 'htl-1' or has 'htl-1' as one of the IDs, and has room 'rm-101' for router default compatibility!
#    Specifically, the first hotel can have id: 'htl-1', name: 'Hotel Tentrem Yogyakarta' or 'Grand Inna Malioboro'.
# 5. Clean Dart syntax, no unescaped strings, valid double/int literals, valid imports.


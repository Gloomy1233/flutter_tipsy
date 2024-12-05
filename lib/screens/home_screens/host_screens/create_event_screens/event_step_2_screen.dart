import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/services/firebase_call_events_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nominatim_flutter/model/request/search_request.dart';
import 'package:nominatim_flutter/model/response/reverse_response.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/app_theme_text_form_field.dart';

class EventStep2Screen extends StatefulWidget {
  const EventStep2Screen({super.key});

  @override
  _EventStep2ScreenState createState() => _EventStep2ScreenState();
}

class _EventStep2ScreenState extends State<EventStep2Screen> {
  late TextEditingController countryController;
  late TextEditingController addressController;
  late TextEditingController numberController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController dateOfBirthController;
  @override
  void initState() {
    super.initState();

    countryController = TextEditingController(text: '');
    addressController = TextEditingController(text: '');
    numberController = TextEditingController(text: '');
    cityController = TextEditingController(text: '');
    stateController = TextEditingController(text: '');
    postalCodeController = TextEditingController(text: '');
    dateOfBirthController = TextEditingController(text: "2000-01-21");
    _latitude = 31.43296265331129;
    _longitude = -122.08832357078792;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadThemes() async {
    WriteBatch batch = _firestore.batch();
    CollectionReference themesRef = _firestore.collection('partyThemes');
    for (Map<String, dynamic> vik in themeList) {
      DocumentReference docRef = themesRef.doc(); // Auto-generated ID
      batch.set(docRef, vik);
      await batch.commit();
    }
    try {
      await batch.commit();
      print('All themes uploaded successfully!');
    } catch (e) {
      print('Error uploading themes: $e');
    }
  }

  List<Map<String, dynamic>> themeList = [
    // Theme 1
    {
      'Title': 'Roaring 20s / Great Gatsby',
      'Decor': 'Art Deco patterns, feather centerpieces, vintage props.',
      'Attire': 'Flapper dresses, suits with suspenders, fedoras.',
      'Activities':
          'Jazz music, Charleston dance lessons, photo booth with vintage props.',
    },
    // Theme 2
    {
      'Title': 'Hollywood Red Carpet',
      'Decor':
          'Red carpet entrance, gold and black color scheme, star-studded backdrops.',
      'Attire': 'Glamorous evening wear, formal dresses, tuxedos.',
      'Activities': 'Paparazzi photo ops, awards ceremony, movie trivia.',
    },
    // Theme 3
    {
      'Title': 'Tropical Luau',
      'Decor':
          'Tiki torches, Hawaiian leis, palm leaves, colorful table settings.',
      'Attire': 'Hawaiian shirts, grass skirts, flip-flops.',
      'Activities': 'Limbo contests, hula dancing, tropical cocktails.',
    },
    // Theme 4
    {
      'Title': 'Masquerade Ball',
      'Decor': 'Elegant masks, rich fabrics, chandeliers, candlelight.',
      'Attire': 'Formal wear with elaborate masks.',
      'Activities': 'Mask-making station, classical music, dance floor.',
    },
    // Theme 5
    {
      'Title': '80s Neon Party',
      'Decor': 'Neon lights, retro posters, colorful streamers.',
      'Attire': 'Bright, neon clothing, leg warmers, big hair.',
      'Activities': '80s music playlist, dance-offs, arcade games.',
    },
    // Theme 6
    {
      'Title': 'Harry Potter Wizarding World',
      'Decor': 'Hogwarts house banners, floating candles, potion bottles.',
      'Attire': 'Hogwarts robes, house scarves, wizard hats.',
      'Activities': 'Trivia games, wand-making, themed snacks like Butterbeer.',
    },
    // Theme 7
    {
      'Title': 'Black and White Affair',
      'Decor': 'Monochromatic decorations, elegant table settings.',
      'Attire': 'Black and white outfits.',
      'Activities':
          'Sophisticated cocktails, jazz or classical music, photo booth with black and white props.',
    },
    // Theme 8
    {
      'Title': 'Space / Galaxy',
      'Decor':
          'Starry lights, planets, cosmic backdrops, dark color schemes with glitter.',
      'Attire':
          'Futuristic outfits, space-themed costumes, metallic accessories.',
      'Activities':
          'Stargazing setup, sci-fi movie screenings, space-themed games.',
    },
    // Theme 9
    {
      'Title': 'Carnival / Circus',
      'Decor': 'Bright colors, striped tents, carnival games setups.',
      'Attire':
          'Colorful, playful outfits, clown accessories, ringmaster costumes.',
      'Activities':
          'Game booths, cotton candy station, live performances like juggling or magic shows.',
    },
    // Theme 10
    {
      'Title': 'Winter Wonderland',
      'Decor':
          'Snowflakes, white and blue color palette, fairy lights, ice sculptures.',
      'Attire': 'Cozy winter clothing, glittery outfits.',
      'Activities':
          'Hot chocolate bar, ice skating (if possible), winter-themed games.',
    },
    // Theme 11
    {
      'Title': 'Superhero Bash',
      'Decor': 'Comic book posters, cityscape backdrops, superhero symbols.',
      'Attire': 'Costumes of favorite superheroes or create your own.',
      'Activities': 'Superhero trivia, costume contests, themed photo ops.',
    },
    // Theme 12
    {
      'Title': 'Beach Party',
      'Decor': 'Sand, beach balls, umbrellas, seashells.',
      'Attire': 'Swimwear, Hawaiian shirts, sunglasses.',
      'Activities': 'Beach volleyball, limbo, tropical drinks and BBQ.',
    },
    // Theme 13
    {
      'Title': 'Decades Party',
      'Decor': 'Era-specific decorations, music, and props.',
      'Attire': 'Clothing styles from the chosen decade.',
      'Activities': 'Dance to hits from the decade, trivia, themed games.',
    },
    // Theme 14
    {
      'Title': 'Fairy Tale Fantasy',
      'Decor': 'Enchanted forest elements, castles, magical lighting.',
      'Attire':
          'Costumes of fairy tale characters like princesses, knights, or mythical creatures.',
      'Activities': 'Storytelling, themed games, magical photo booth.',
    },
    // Theme 15
    {
      'Title': 'Blacklight / Glow Party',
      'Decor': 'Blacklights, neon decorations, glow-in-the-dark elements.',
      'Attire': 'Fluorescent clothing, accessories that glow under blacklight.',
      'Activities': 'Glow stick dance floor, UV face painting, neon drinks.',
    },
    // Theme 16
    {
      'Title': 'Around the World',
      'Decor': 'Flags, cultural decorations from various countries.',
      'Attire': 'Traditional outfits from different cultures.',
      'Activities':
          'International food tasting, cultural performances, passport-style invitations.',
    },
    // Theme 17
    {
      'Title': 'Mystery / Murder Party',
      'Decor': 'Suspenseful and moody settings, themed props.',
      'Attire': 'Characters based on the mystery storyline.',
      'Activities':
          'Interactive mystery-solving games, clue hunts, role-playing.',
    },
    // Theme 18
    {
      'Title': 'Vintage Tea Party',
      'Decor': 'Elegant table settings, floral arrangements, vintage china.',
      'Attire': 'Tea dresses, hats, gloves.',
      'Activities':
          'Tea tasting, finger foods, classic games like croquet or bridge.',
    },
    // Theme 19
    {
      'Title': 'Neon Retro Arcade',
      'Decor': 'Bright neon lights, retro arcade games, pixel art.',
      'Attire': 'Retro gaming-inspired outfits, colorful accessories.',
      'Activities':
          'Arcade game stations, high-score competitions, themed snacks.',
    },
    // Theme 20
    {
      'Title': 'Enchanted Garden',
      'Decor':
          'Floral arrangements, fairy lights, greenery, whimsical elements.',
      'Attire': 'Garden party chic, floral prints, light and airy clothing.',
      'Activities': 'Garden games, flower crown making, outdoor music.',
    },
    // Theme 21
    {
      'Title': 'Medieval Feast',
      'Decor':
          'Long wooden tables, banners with coats of arms, candles, faux stone walls.',
      'Attire': 'Knights, princesses, jesters, medieval gowns and armor.',
      'Activities':
          'Jousting games (with foam), medieval music, storytelling, flag making.',
    },
    // Theme 22
    {
      'Title': 'Pirate Adventure',
      'Decor': 'Treasure chests, nautical ropes, maps, pirate flags.',
      'Attire': 'Pirate costumes, eye patches, bandanas, striped shirts.',
      'Activities':
          'Treasure hunts, sword fighting (with foam swords), nautical-themed games.',
    },
    // Theme 23
    {
      'Title': 'Disco Fever',
      'Decor': 'Disco balls, colorful lights, retro patterns, vinyl records.',
      'Attire': 'Bell-bottoms, sequined outfits, platform shoes, afro wigs.',
      'Activities': 'Dance-offs, disco music playlists, karaoke with 70s hits.',
    },
    // Theme 24
    {
      'Title': 'Alice in Wonderland',
      'Decor':
          'Tea party setups, oversized playing cards, whimsical flowers, mushrooms.',
      'Attire':
          'Eccentric and colorful outfits, hats, costumes of characters like the Mad Hatter or Cheshire Cat.',
      'Activities':
          'Tea tasting, croquet with flamingo mallets, interactive story segments.',
    },
    // Theme 25
    {
      'Title': 'Mardi Gras',
      'Decor':
          'Beads, masks, vibrant purple, green, and gold colors, feathers.',
      'Attire': 'Festive and colorful outfits, masks, feathered accessories.',
      'Activities':
          'Mask decorating, jazz or brass band music, bead throwing, dance parties.',
    },
    // Theme 26
    {
      'Title': 'Steampunk',
      'Decor':
          'Gears, cogs, vintage machinery, metallic accents, Victorian-inspired elements.',
      'Attire':
          'Victorian-era clothing with steampunk accessories like goggles, corsets, and top hats.',
      'Activities':
          'DIY gadget making, themed photo booth, steampunk-themed games.',
    },
    // Theme 27
    {
      'Title': 'Jungle Safari',
      'Decor': 'Green foliage, animal prints, safari gear, wooden elements.',
      'Attire': 'Khaki outfits, safari hats, animal costumes.',
      'Activities':
          'Safari scavenger hunt, animal-themed games, tropical drinks and snacks.',
    },
    // Theme 28
    {
      'Title': 'Around the Movies',
      'Decor': 'Movie posters, popcorn machines, red carpets, clapboards.',
      'Attire':
          'Costumes of favorite movie characters, glamorous Hollywood styles.',
      'Activities':
          'Movie screenings, trivia based on popular films, costume contests.',
    },
    // Theme 29
    {
      'Title': 'Circus Extravaganza',
      'Decor':
          'Bright stripes, big top tent elements, colorful banners, balloons.',
      'Attire':
          'Circus performers like clowns, acrobats, ringmasters, or audience members with playful outfits.',
      'Activities':
          'Mini performances, balloon artists, face painting, carnival games.',
    },
    // Theme 30
    {
      'Title': 'Arabian Nights',
      'Decor':
          'Rich fabrics, lanterns, cushions, intricate patterns, palm leaves.',
      'Attire':
          'Middle Eastern-inspired outfits, flowing garments, harem pants, turbans.',
      'Activities':
          'Belly dancing performances or lessons, hookah lounge area, themed storytelling.',
    },
    // Theme 31
    {
      'Title': 'Fiesta / Mexican Fiesta',
      'Decor': 'Bright colors, papel picado banners, sombreros, cacti.',
      'Attire': 'Colorful, festive clothing, sombreros, ponchos.',
      'Activities': 'Salsa dancing, piñata games, taco and margarita bars.',
    },
    // Theme 32
    {
      'Title': 'Wild West',
      'Decor': 'Hay bales, saloon doors, rustic wood, cowboy hats and boots.',
      'Attire': 'Cowboy and cowgirl outfits, western wear, bandanas.',
      'Activities': 'Line dancing, mechanical bull riding, country music, BBQ.',
    },
    // Theme 33
    {
      'Title': 'Space Odyssey',
      'Decor': 'Metallics, star projections, futuristic props, planets.',
      'Attire': 'Astronaut suits, aliens, futuristic fashion.',
      'Activities':
          'Virtual reality space experiences, sci-fi trivia, space-themed photo ops.',
    },
    // Theme 34
    {
      'Title': 'Disney Magic',
      'Decor':
          'Decorations themed around favorite Disney movies, character cutouts, fairy lights.',
      'Attire':
          'Disney character costumes, princess dresses, themed accessories.',
      'Activities':
          'Disney karaoke, trivia, themed games, character meet-and-greets.',
    },
    // Theme 35
    {
      'Title': 'Pyjama Party',
      'Decor': 'Cozy blankets, pillows, fairy lights, comfy seating areas.',
      'Attire': 'Pyjamas, onesies, slippers.',
      'Activities':
          'Movie marathon, pillow fights, DIY snack stations, storytelling.',
    },
    // Theme 36
    {
      'Title': 'Candyland Sweet Party',
      'Decor':
          'Bright, colorful candy decorations, oversized lollipops, candy canes.',
      'Attire': 'Bright and playful outfits, candy-themed accessories.',
      'Activities': 'Candy buffets, sweet-themed games, DIY candy stations.',
    },
    // Theme 37
    {
      'Title': 'Art Party / Paint and Sip',
      'Decor': 'Easels, canvases, colorful decorations, art supplies.',
      'Attire': 'Casual, paint-friendly clothing, aprons.',
      'Activities':
          'Guided painting sessions, wine or mocktail tasting, art display.',
    },
    // Theme 38
    {
      'Title': 'Bollywood Extravaganza',
      'Decor':
          'Rich colors, intricate patterns, lanterns, Bollywood movie posters.',
      'Attire':
          'Traditional Indian clothing like sarees, lehengas, kurtas, and sherwanis.',
      'Activities':
          'Bollywood dance lessons, henna tattoos, Indian cuisine tasting.',
    },
    // Theme 39
    {
      'Title': 'Neon Glow Pool Party',
      'Decor': 'Blacklights, glow sticks, neon inflatables, LED pool lights.',
      'Attire': 'Neon swimwear, glow accessories, UV-reactive clothing.',
      'Activities':
          'Pool games, glow dancing, water-based activities, neon-themed drinks.',
    },
    // Theme 40
    {
      'Title': 'Farmyard Fun',
      'Decor':
          'Barn elements, hay bales, checkered tablecloths, rustic farm decor.',
      'Attire': 'Casual, country-style clothing, overalls, cowboy hats.',
      'Activities':
          'Petting zoos, tractor rides, barn dance, homemade pie contests.',
    },
    // Theme 41
    {
      'Title': 'Disco Inferno',
      'Decor': 'Glitter, disco balls, vibrant colors, retro patterns.',
      'Attire': '70s-inspired outfits, bell-bottoms, platform shoes.',
      'Activities':
          'Dance-offs with disco music, karaoke, retro game stations.',
    },
    // Theme 42
    {
      'Title': 'Vintage Carnival',
      'Decor': 'Antique carnival games, vintage signage, nostalgic colors.',
      'Attire': 'Retro clothing, vintage circus-inspired outfits.',
      'Activities':
          'Classic carnival games, cotton candy machines, fortune tellers.',
    },
    // Theme 43
    {
      'Title': 'Outer Space Alien Invasion',
      'Decor': 'UFOs, aliens, starry backdrops, metallic and neon colors.',
      'Attire': 'Alien costumes, futuristic outfits, space-themed accessories.',
      'Activities':
          'Alien makeup stations, sci-fi movie screenings, themed scavenger hunts.',
    },
    // Theme 44
    {
      'Title': 'Wildflower Garden Party',
      'Decor':
          'Fresh flowers, pastel colors, rustic tablescapes, floral garlands.',
      'Attire': 'Floral prints, light and breezy clothing, garden hats.',
      'Activities':
          'Flower arranging, outdoor games like croquet, live acoustic music.',
    },
    // Theme 45
    {
      'Title': 'Egyptian Pharaoh',
      'Decor': 'Hieroglyphics, pyramids, golden accents, sphinx statues.',
      'Attire':
          'Egyptian-inspired costumes, pharaoh headdresses, Cleopatra-style dresses.',
      'Activities':
          'Archaeological treasure hunts, Egyptian-themed games, belly dancing.',
    },
    // Theme 46
    {
      'Title': 'Mythical Creatures',
      'Decor': 'Enchanted forests, mythical symbols, ethereal lighting.',
      'Attire': 'Costumes of unicorns, dragons, fairies, mermaids.',
      'Activities': 'Storytelling sessions, mythical trivia, costume contests.',
    },
    // Theme 47
    {
      'Title': 'Secret Garden',
      'Decor': 'Overgrown greenery, vintage keys, fairy lights, hidden nooks.',
      'Attire': 'Botanical prints, earthy tones, whimsical accessories.',
      'Activities': 'Garden tours, planting stations, nature-inspired crafts.',
    },
    // Theme 48
    {
      'Title': 'Time Traveler\'s Ball',
      'Decor':
          'Elements from various historical periods, clocks, timepiece motifs.',
      'Attire':
          'Mix-and-match outfits from different eras, steampunk accessories.',
      'Activities': 'Time-themed games, historical trivia, costume showcasing.',
    },
    // Theme 49
    {
      'Title': 'Neon Rave Party',
      'Decor':
          'Vibrant neon colors, laser lights, glow-in-the-dark decorations.',
      'Attire': 'Bright, fluorescent clothing, LED accessories, rave gear.',
      'Activities':
          'DJ or live electronic music, dance floor with light effects, glow stick dancing.',
    },
    // Theme 50
    {
      'Title': 'Literary Soirée',
      'Decor':
          'Book-themed decorations, quotes from famous literature, cozy reading nooks.',
      'Attire':
          'Outfits inspired by favorite book characters, literary-themed accessories.',
      'Activities':
          'Book readings, literary trivia, storytelling, book exchange.',
    },
    // Theme 51
    {
      'Title': 'Oktoberfest',
      'Decor':
          'Bavarian flags, beer steins, pretzel displays, rustic wooden tables.',
      'Attire': 'Traditional German outfits like lederhosen and dirndls.',
      'Activities':
          'Beer tasting, traditional German music and dancing, bratwurst grilling.',
    },
    // Theme 52
    {
      'Title': 'Neon Jungle Party',
      'Decor':
          'Exotic animal prints with neon accents, vibrant plants, colorful lights.',
      'Attire': 'Bright, animal-inspired outfits, neon accessories.',
      'Activities':
          'Jungle-themed games, dance-offs with tropical beats, neon face painting.',
    },
    // Theme 53
    {
      'Title': 'Great Outdoors / Camping',
      'Decor':
          'Tents, fairy lights, campfire setups, nature-inspired elements.',
      'Attire': 'Outdoor wear, flannel shirts, hiking gear.',
      'Activities':
          'Storytelling around a faux campfire, outdoor games, s\'mores making.',
    },
    // Theme 54
    {
      'Title': 'Disco Glam',
      'Decor': 'Glitter, metallics, disco balls, vibrant lighting.',
      'Attire': 'Glamorous 70s outfits, sequined dresses, platform shoes.',
      'Activities':
          'Disco dancing, karaoke with classic hits, dance competitions.',
    },
    // Theme 55
    {
      'Title': 'Scandinavian Hygge',
      'Decor':
          'Minimalist designs, cozy blankets, candles, natural elements like wood and greenery.',
      'Attire': 'Comfortable, cozy clothing, sweaters, scarves.',
      'Activities':
          'Hot beverage stations, board games, relaxed conversations, crafting.',
    },
    // Theme 56
    {
      'Title': 'Sci-Fi Cyberpunk',
      'Decor':
          'Neon lights, futuristic cityscapes, high-tech props, metallic accents.',
      'Attire': 'Futuristic outfits, cybernetic accessories, LED elements.',
      'Activities':
          'Virtual reality stations, sci-fi trivia, themed photo ops.',
    },
    // Theme 57
    {
      'Title': 'Rustic Barn Party',
      'Decor':
          'Wooden barns or rustic backdrops, string lights, mason jars, hay bales.',
      'Attire': 'Country chic, denim, plaid shirts, cowboy boots.',
      'Activities': 'Line dancing, BBQ cook-offs, live country music.',
    },
    // Theme 58
    {
      'Title': 'Haunted House Party',
      'Decor': 'Spooky decorations, cobwebs, eerie lighting, haunted props.',
      'Attire': 'Halloween costumes, ghostly attire, spooky makeup.',
      'Activities': 'Scavenger hunts, horror movie screenings, haunted maze.',
    },
    // Theme 59
    {
      'Title': 'Arabian Desert Oasis',
      'Decor': 'Desert-themed elements, tents, lanterns, rich fabrics.',
      'Attire':
          'Middle Eastern-inspired clothing, flowing garments, headscarves.',
      'Activities':
          'Belly dancing, henna tattoo stations, themed storytelling.',
    },
    // Theme 60
    {
      'Title': 'Literary Characters',
      'Decor':
          'Elements inspired by famous books and literary settings, cozy reading corners.',
      'Attire':
          'Costumes of beloved literary characters from books and novels.',
      'Activities':
          'Book-themed trivia, storytelling sessions, book exchange or swap.',
    },
    // Theme 61
    {
      'Title': 'Futuristic Neon Party',
      'Decor':
          'Sleek metallics, neon lights, holographic elements, futuristic props.',
      'Attire': 'Space-age outfits, LED accessories, metallic clothing.',
      'Activities':
          'Laser light shows, electronic music DJ sets, futuristic photo booths.',
    },
    // Theme 62
    {
      'Title': 'Art Deco Elegance',
      'Decor':
          'Geometric patterns, gold and black color schemes, vintage glam.',
      'Attire':
          '1920s-inspired fashion, flapper dresses, tuxedos with bow ties.',
      'Activities':
          'Jazz music, dance lessons (Charleston or swing), elegant cocktail tastings.',
    },
    // Theme 63
    {
      'Title': 'Graffiti Street Party',
      'Decor': 'Urban art, colorful graffiti backdrops, industrial elements.',
      'Attire': 'Streetwear, bold and colorful outfits, sneakers.',
      'Activities':
          'Live graffiti artists, street dance performances, urban music playlists.',
    },
    // Theme 64
    {
      'Title': 'Tropical Rainforest',
      'Decor': 'Lush greenery, exotic plants, animal prints, water features.',
      'Attire': 'Tropical prints, safari gear, bright and airy clothing.',
      'Activities':
          'Nature-inspired games, tropical drink stations, eco-friendly crafts.',
    },
    // Theme 65
    {
      'Title': 'Vintage Hollywood',
      'Decor':
          'Old Hollywood glamour, classic movie posters, elegant lighting.',
      'Attire':
          'Glamorous vintage outfits, red carpet styles, classic accessories.',
      'Activities':
          'Movie screenings, photo ops with Hollywood props, awards or talent shows.',
    },
    // Theme 66
    {
      'Title': 'Neon Cyber Party',
      'Decor': 'Cyberpunk aesthetics, neon lights, tech-inspired decorations.',
      'Attire': 'Futuristic outfits, cybernetic accessories, neon accents.',
      'Activities':
          'Virtual reality experiences, electronic dance music, tech-themed games.',
    },
    // Theme 67
    {
      'Title': 'Greek Mythology',
      'Decor':
          'Columns, olive branches, statues of gods and goddesses, white and gold accents.',
      'Attire': 'Togas, goddess and god costumes, laurel wreaths.',
      'Activities':
          'Mythology trivia, themed storytelling, Greek-inspired games.',
    },
    // Theme 68
    {
      'Title': 'Fairy Forest',
      'Decor':
          'Enchanted forest elements, fairy lights, mushrooms, toadstools.',
      'Attire': 'Fairy costumes, woodland-inspired outfits, ethereal clothing.',
      'Activities':
          'Fairy tale storytelling, nature crafts, magical photo booths.',
    },
    // Theme 69
    {
      'Title': 'Movie Marathon Night',
      'Decor':
          'Cozy seating, projector screens, themed decorations based on chosen movies.',
      'Attire':
          'Comfortable loungewear, pajamas, themed costumes of movie characters.',
      'Activities':
          'Continuous movie screenings, themed snacks, interactive discussions between films.',
    },
    // Theme 70
    {
      'Title': 'Global Street Food Festival',
      'Decor':
          'Booth-style setups representing different countries, vibrant and colorful decorations.',
      'Attire':
          'Casual, travel-inspired outfits, cultural attire from various regions.',
      'Activities':
          'International food tasting stations, live cooking demonstrations, cultural performances.',
    },
    // Theme 71
    {
      'Title': 'Neon Paint Party',
      'Decor':
          'Blacklights, neon decorations, paint splatters, glow-in-the-dark elements.',
      'Attire':
          'White or neon clothing, paint-friendly outfits, glow accessories.',
      'Activities':
          'Live body painting, dance floor with neon paint, glow stick activities.',
    },
    // Theme 72
    {
      'Title': 'Fantasy Medieval',
      'Decor': 'Castles, dragons, medieval banners, enchanted forests.',
      'Attire':
          'Fantasy-inspired costumes like elves, wizards, knights, and mythical creatures.',
      'Activities':
          'Role-playing games, medieval-themed contests, storytelling sessions.',
    },
    // Theme 73
    {
      'Title': 'Candy Couture',
      'Decor':
          'Sweet-themed decorations, oversized candy props, pastel colors.',
      'Attire':
          'Bright and colorful outfits inspired by candy, playful accessories.',
      'Activities': 'DIY candy stations, sweet-themed games, candy tastings.',
    },
    // Theme 74
    {
      'Title': 'Vintage Circus',
      'Decor':
          'Classic circus elements, striped tents, vintage posters, old-fashioned games.',
      'Attire': 'Vintage circus costumes, ringmaster outfits, clown attire.',
      'Activities':
          'Traditional circus games, live performances, popcorn and cotton candy stations.',
    },
    // Theme 75
    {
      'Title': 'Retro Video Game Party',
      'Decor': 'Pixelated decorations, classic game posters, arcade machines.',
      'Attire':
          'Outfits inspired by retro video game characters, casual and colorful clothing.',
      'Activities':
          'Retro gaming stations, high-score competitions, video game-themed snacks.',
    },
    // Theme 76
    {
      'Title': 'Medieval Masquerade',
      'Decor': 'Rich fabrics, ornate masks, candlelight, gothic elements.',
      'Attire': 'Medieval-inspired formal wear with elaborate masks.',
      'Activities':
          'Mask contests, medieval music and dancing, themed storytelling.',
    },
    // Theme 77
    {
      'Title': 'Nautical / Sailor Party',
      'Decor':
          'Anchors, ropes, navy blue and white color schemes, ship wheels.',
      'Attire': 'Nautical stripes, sailor outfits, captain hats.',
      'Activities': 'Boat-themed games, seafood tasting, maritime trivia.',
    },
    // Theme 78
    {
      'Title': 'Arabian Bazaar',
      'Decor': 'Colorful textiles, lanterns, market stalls, rich patterns.',
      'Attire': 'Middle Eastern-inspired clothing, flowing robes, headscarves.',
      'Activities':
          'Spice tasting, henna tattoos, traditional music and dance.',
    },
    // Theme 79
    {
      'Title': 'Supernatural / Ghost Party',
      'Decor':
          'Eerie decorations, ghostly apparitions, dark color schemes, fog machines.',
      'Attire': 'Ghost costumes, supernatural beings, spooky attire.',
      'Activities':
          'Ghost stories, haunted house tours, supernatural-themed games.',
    },
    // Theme 80
    {
      'Title': 'Retro 90s Party',
      'Decor': 'Bright colors, neon accents, iconic 90s memorabilia.',
      'Attire':
          '90s fashion like baggy jeans, graphic tees, scrunchies, and chokers.',
      'Activities':
          '90s music playlists, dance-offs, retro game stations, karaoke with 90s hits.',
    },
  ];

  Timer? _debounce;

  List<NominatimResponse> _searchResults = [];
  bool _showDropdown = false;

  final String apiKey =
      "AIzaSyAgMuRPnAf9vv8APMnuGDjgohOzaLUoCIE"; // Replace with your Google API Key
  String result = "";

  void _onAddressChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (addressController.text.length >= 3) {
        searchResults();
        _showDropdown = true;
      } else {
        setState(() {
          _showDropdown = false;
          _searchResults.clear();
        });
      }
    });
  }

  // Function to perform the API call
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.958106, 23.744551),
    zoom: 18,
  );
  Set<Marker> _markers = {};
  late double _latitude;
  late double _longitude;

  @override
  void dispose() {
    dateOfBirthController.dispose();
    _debounce?.cancel();
    addressController.removeListener(_onAddressChanged);

    super.dispose();
  }

  GeoLocationService geoLocationService = GeoLocationService();
  bool isAddressVisible = false;
  Future<void> _initializeStream() async {
    Position? position = await GeoLocationService().getCurrentLocation();

    if (position != null) {
      // Save the user's location to Firestore
      position = await GeoLocationService().getCurrentLocation();

      if (position != null) {
      } else {
        setState(() {});
        return;
      }
    }
  }

  void searchResults() async {
    List<NominatimResponse> list = await NominatimFlutter.instance.search(
      searchRequest: SearchRequest(
        query: addressController.text,
        limit: 3,
        addressDetails: true,
        extraTags: false,
        nameDetails: true,
      ),
      language: 'en-US,en;q=0.5', // Specify the desired language(s) here
    );
    updateSearchResults(list);
  }

  void updateSearchResults(List<NominatimResponse> newResults) {
    setState(() {
      _searchResults = newResults;
      _showDropdown = _searchResults.isNotEmpty;
    });
  }

  Future<void> searchAddress() async {
    String googleApiKey = apiKey;
    final bool isDebugMode = true;
    final api = GoogleGeocodingApi(googleApiKey, isLogged: isDebugMode);

    String fullAddress =
        '${addressController.text} ${numberController.text}'.trim();

    final searchResults = await api.search(fullAddress);

    // setState(() {
    //   _searchResults = searchResults.results
    //       .map((result) => result.mapToPretty())
    //       .where((address) => address != null)
    //       .toList();
    //   _showDropdown = _searchResults.isNotEmpty;
    // });
  }

  void _selectAddress(GeocodingPrettyAddress address) {
    setState(() {
      countryController.text = address.country ?? '';
      addressController.text = address.streetName ?? '';
      numberController.text = address.streetNumber ?? '';
      cityController.text = address.city ?? '';
      stateController.text = address.state ?? '';
      postalCodeController.text = address.postalCode ?? '';
      _latitude = address.latitude;
      _longitude = address.longitude;
      _showDropdown = false;
    });

    _addMarker(LatLng(_latitude, _longitude));
    _animateToAddress();
  }

  @override
  Widget build(BuildContext context) {
    uploadThemes();
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          // Heading
          SizedBox(height: 15),
          Text(
            "Where is your event located",
            style: TextStyle(
              color: primaryDark,
              fontSize: 18.sp,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 5),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: AppThemeTextFormField(
                      controller: addressController,
                      labelText: "Address",
                      hintText: "Φιλωνος",
                      onChanged: (value) => _onAddressChanged(),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 25,
                    child: AppThemeTextFormField(
                      controller: numberController,
                      labelText: "Number",
                      hintText: "18",
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              if (_showDropdown)
                Container(
                  width: 65.w,
                  constraints: BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: primaryDarkEvenLighter,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final address = _searchResults[index];
                      return ListTile(
                        title: Text(
                          address.address?.values.toString() ?? '',
                          style: TextStyle(fontSize: 14, color: primaryDark),
                        ),
                        onTap: () {
                          var sw = true;
                          if (sw) {
                            uploadThemes();
                            print('uploading themes');
                            sw = false;
                          }
                          // Handle address selection
                          address.address?.forEach((key, value) {
                            switch (key) {
                              case 'country':
                                countryController.text = value;
                                break;
                              case 'city':
                                cityController.text = value;
                                break;
                              case 'state':
                                stateController.text = value;
                                break;
                              case 'postcode':
                                postalCodeController.text = value;
                                break;
                              case 'road':
                                addressController.text = value;
                                break;
                              case 'house_number':
                                numberController.text = value;
                                break;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),

          SizedBox(height: 5),

          // City and State
          Row(
            children: [
              // City
              Expanded(
                flex: 1,
                child: AppThemeTextFormField(
                  controller: cityController,
                  labelText: "City",
                  hintText: "Αθηνα",
                  onChanged: (value) {
                    // Handle city input change
                  },
                ),
              ),
              SizedBox(height: 5),
              // State
              Expanded(
                flex: 1,
                child: AppThemeTextFormField(
                  controller: stateController,
                  labelText: "State",
                  hintText: "",
                  onChanged: (value) {
                    // Handle state input change
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 5),

          // Postal Code
          AppThemeTextFormField(
            controller: postalCodeController,
            labelText: "Postal Code",
            hintText: "18454",
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Handle postal code input change
            },
          ),
          SizedBox(height: 5),

          // Country/Region
          AppThemeTextFormField(
            controller: countryController,
            labelText: "Country/Region",
            hintText: "Greece",
            suffixIcon: Icon(Icons.arrow_drop_down, color: primaryDark),
            onChanged: (value) {},
          ),

          SizedBox(height: 5),

          // Use Current Location Button

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40.w,
                decoration: BoxDecoration(
                    //shape: BoxShape.circle,
                    gradient: gradient,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        blurRadius: 6,
                      ),
                    ],
                    border: Border.all(color: primaryDark, width: 1)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3.w),
                    onTap: () {
                      _initializeStream();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location_sharp,
                              color: primaryDark, size: 16.sp),
                          SizedBox(height: 5),
                          Text(
                            "Use Current Location",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.w,
                decoration: BoxDecoration(
                    //shape: BoxShape.circle,
                    gradient: gradient,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        blurRadius: 6,
                      ),
                    ],
                    border: Border.all(color: primaryDark, width: 1)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3.w),
                    onTap: () {
                      searchAddress();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              color: primaryDark, size: 16.sp),
                          SizedBox(height: 5),
                          Text(
                            "Check Address",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Navigation Buttons
        ],
      ),
    );
  }

  void _addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
          title: 'This is title', snippet: 'This is a custom marker'),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> _animateToAddress() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_latitude, _longitude),
      zoom: 18,
      bearing: 0,
      tilt: 0,
    )));
  }
}

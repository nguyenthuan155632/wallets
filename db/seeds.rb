# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'abc@gmail.com', password: '123456', password_confirmation: '123456')

Trash.find_or_create_by(contract_name: 'PDot.io')
Trash.find_or_create_by(contract_name: 'yetiswap.io')

['BNBW.IO', 'BestAir.io', 'LinkP.io', 'ARKR.org', 'FF18.io', 'GemSwap.net', 'Zepe.io', 'TheVera.io', 'GoFlux.io',
 'KK8.io', '1Gas.org', 'Def8.io', 'TheEver.io', '0Fees.online', 'Minereum BSC', 'BSCmello.io', 'xshibpoly.io',
 'AAABC.net', 'abodan.net',
 'agte.me', 'Dragon Blood', 'DeXe', 'Binamon', 'Titan Hunters',
 'Fusion Heroes Token', 'SIL Finance Token V2', 'DungeonSwap Token', 'AAExchange.io', 'immcoin.io', 'payou.finance',
 'Monster Token', 'NestFin.Net', 'Heroes&Empires', 'LeonicornSwap', 'DeathRoad Token', 'Poly-Peg ONG', 'AmpleSwap Token',
 'PlanetSandbox', 'fry.world', 'Poco Token', 'Fusible | Fusible.io', 'DinoX Coin', 'LIGHTENING.CASH', 'ACryptoS',
 'Tu7.org', 'MetaWars', 'Bemil', 'USD Open Dollar', 'Kryoss.Net', 'ApeSwapFinance LPs',
 'Swap7.org', 'MCDEX Token', 'ApeSwapFinance Banana', 'Dragon Warrior', 'Meta Spatial', 'AABEK.net', 'HeroVerse Token',
 'Oly Sport', 'NAOSToken', 'TryHards', 'SHIBA_DIVIDEND_TRACKER', 'CZFarm', 'DeathRoad xDRACEV2', 'aaexchange.io',
 'Gunstar Metaverse', 'Token GON+', 'Green Beli', 'h3x.exchange', 'GameFi', 'OpenOcean', 'SyrupBar Token',
 'The Spartans', 'IOI Token  via ChainPort.io', 'IoTeX Network', 'CryptEx Token', 'ShopNext Token', 'MetaMask.io',
 'Chainport.io-Peg Fear NFTs', 'MDX Token', 'Landshare Token', 'Thetan Gem', 'WIDI', 'melloBsc.com', 'Pet Kingdom Token',
 'Warena Token', 'Binapet', 'XCH5.io', 'Survival', 'CHEERS', 'BSCS Token', 'Lorda Token', 'GourmetGalaxy', 'MechMaster',
 'Starpunk', 'Pancake LPs', 'Good Games Guild', 'Gains', 'SAFEMOON_DIVIDEND_TRACKER', 'MMdex.io',
 'shibainu-dividend.com', 'https://t.me/AirDoge', 'rocketboys.io', 'Xpool', 'O3 Swap Token',
 'NerveNetwork', 'INP', 'mymasterwar.com', 'MonsterBattleSouls', 'FaraCrystal', 'MonsterWar', 'NEXTYPE', 'POG Coin'].each do |trash|
  Trash.find_or_create_by(contract_name: trash)
end

['AGMC.io', 'BSCTOKEN.IO', 'AirStack.net', 'FAIR SQUID', 'LaunchZone',
 'CryptoBlades Skill Token', 'Kawaii Token', 'The Three Kingdoms', 'xch5.net', 'Milkyswap.io', 'Plant2Earn',
 'ShibaDrop.io', 'ABFIN.org', 'Mogul Stars'].each do |trash|
  Trash.find_or_create_by(contract_name: trash)
end

Network.find_or_create_by(network_name: 'Binance Smart Chain', chain_id: 56, user: user)
Network.find_or_create_by(network_name: 'Avalanche', chain_id: 43_114, user: user)

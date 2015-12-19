namespace :data do

  desc 'This will seed data into aircraft types table'

  task seed_aircraft_types: :environment do

    types =  [
        'American Champion 8GCBC SCOUT',
        'Beechcraft 400A',
        'Beechcraft Hawker 750',
        'Beechcraft Hawker 800XP',
        'Beechcraft Hawker 850XP',
        'Beechcraft Hawker 900XP',
        'Beechcraft Hawker Premier 1A',
        'Beechcraft King Air B200',
        'Beechcraft King Air B-200GT',
        'Beechcraft King Air C90',
        'Beechcraft King Air C90A',
        'Beechcraft King Air C-90A',
        'Beechcraft King Air C90B',
        'Beechcraft King Air C90GTi',
        'Beechcraft Hawker Premier 1A',
        'Beechcraft Super King Air 350',
        'Beechcraft Super King Air 300',
        'Beechcraft Super King Air B200',
        'Beechcraft Super King Air B200 GT',
        'Beechcraft Super King Air B-200-C',
        'Bombardier Challenger 850',
        'Bombardier Challenger 604',
        'Bombardier Challenger 300',
        'Bombardier Challenger 604',
        'Bombardier CL-600-2B16 Challenger 604',
        'Bombardier Challenger 604',
        'Bombardier Challenger CL-600-B219 CRJ-100',
        'Bombardier Challenger 604',
        'Bombardier Global 5000 BD700',
        'Bombardier Learjet 45',
        'Bombardier Learjet 60XR',
        'Cessna 172',
        'Cessna 172S Skyhawk SP',
        'Cessna 172R',
        'Cessna 172S Skyhawk SP',
        'Cessna 206H',
        'Cessna 525A',
        'Cessna 550 BRAVO',
        'Cessna Citation 525A(CJ2)',
        'Cessna Citation 525 CJ1+',
        '    Cessna Citation 525A(CJ2)',
        'Cessna Citation 550',
        'Cessna Citation 560XL Excel',
        'Cessna Citation 560XL Excel',
        'Cessna Citation 650',
        'Cessna Citation CJ2',
        'Cessna Citation II',
        'Cessna Citation Mustang-510',
        'Cessna Citation S/II',
        'Cessna Citation 560XL Excel',
        'Cessna Citation XLS',
        'Cirrus SR-20',
        'Cirrus SR-22',
        'Dassault Falcon 2000',
        'Dassault Falcon 2000 DX',
        'Dassault Falcon 2000 EX',
        'Dassault Falcon 2000EX Easy',
        'Dassault Falcon 7X',
        'Dornier 228-201',
        'Dornier 228-212',
        'Embraer 135 BJ (Legacy-650)',
        'Embraer 190-100 ECJ/LINEAGE 1000',
        'Embraer EMB500(Phenom 100)',
        'Embraer EMB505 Phenom 300',
        'Gulfstream G200',
        'Gulfstream G-IV',
        'Piaggio P-180 Avanti II',
        'Piaggio P-180 Avanti II',
        'Pilatus PC 12/45',
        'Pilatus PC 12/47',
        'Pilatus PC-12',
        'Piper PA-34-220TSENECA-III',
        'Piper Seneca IV',
        'Piper Seneca PA-34-220T',
        'Piper Super Cub PA-18A 150',
        'VulcanAir P68C',
        'Cessna Caravan 208B'
    ]

    types.each do |t|

      AircraftType.create(
                      name: t
      )

    end

  end

end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Room.create(websocket_ip: "10.211.234.123", websocket_port: "12321", facility_id: "400NI1180", building: "400 NORTH INGALLS BUILDING", building_nickname: "400NIB", room_type: "Classroom")
Room.create(websocket_ip: "10.211.234.124", websocket_port: "12321", facility_id: "BSB1060", building: "BIOLOGICAL SCIENCE BUILDING", building_nickname: "BSB-TBL", room_type: "Classroom")
Room.create(websocket_ip: "10.211.234.125", websocket_port: "12321", facility_id: "CCCB0420", building: "CENTRAL CAMPUS CLASSROOM BLDG", building_nickname: "CCCB", room_type: "Classroom")
Room.create(websocket_ip: "10.211.234.126", websocket_port: "12321", facility_id: "EWRE87", building: "EDUCATION SCHOOL OF", building_nickname: "SEB", room_type: "Class Laboratory")
Room.create(websocket_ip: "10.211.234.127", websocket_port: "12321", facility_id: "SEB1309", building: "400 NORTH INGALLS BUILDING", building_nickname: "400NIB", room_type: "Meeting Room")
Room.create(websocket_ip: "10.211.234.128", websocket_port: "12321", facility_id: "CCCB0460", building: "CENTRAL CAMPUS CLASSROOM BLDG", building_nickname: "CCCB", room_type: "Classroom")

Device.create!(name: "Room", description: "to keep states for the room", room_id: 1)
Device.create!(name: "Projector 1", description: "asset", room_id: 1)
Device.create!(name: "Touch Panel", description: "asset", room_id: 1)
Device.create!(name: "Flat Panel Display 2", description: "asset", room_id: 1)

DeviceState.create(key: "Ceiling Mic Signal", value: "false", device_id: 1)
DeviceState.create(key: "WL Mic Signal", value: "true", device_id: 1)
DeviceState.create(key: "Mic Volume", value: "22", device_id: 1)
DeviceState.create(key: "Source Volume", value: "45", device_id: 1)
DeviceState.create(key: "Current Source 1", value: "1", device_id: 1)
DeviceState.create(key: "Current Source 2", value: "2", device_id: 1)
DeviceState.create(key: "VideoSource1", value: "Document Camera", device_id: 1)
DeviceState.create(key: "VideoSource2", value: "Blu-ray Player", device_id: 1)
DeviceState.create(key: "VideoSource3", value: "Room PC", device_id: 1)

DeviceState.create(key: "Online", value: "true", device_id: 2)
DeviceState.create(key: "Power Is On", value: "true", device_id: 2)
DeviceState.create(key: "Error State", value: "false", device_id: 2)

DeviceState.create(key: "Online", value: "true", device_id: 3)

DeviceState.create(key: "Online", value: "true", device_id: 4)
DeviceState.create(key: "Power Is On", value: "true", device_id: 4)
DeviceState.create(key: "Error State", value: "false", device_id: 4)

DeviceCurrentState.create(key: "Ceiling Mic Signal", value: "false", device_id: 1)
DeviceCurrentState.create(key: "WL Mic Signal", value: "true", device_id: 1)
DeviceCurrentState.create(key: "Mic Volume", value: "22", device_id: 1)
DeviceCurrentState.create(key: "Source Volume", value: "45", device_id: 1)
DeviceCurrentState.create(key: "Current Source 1", value: "1", device_id: 1)
DeviceCurrentState.create(key: "Current Source 2", value: "2", device_id: 1)
DeviceCurrentState.create(key: "VideoSource1", value: "Document Camera", device_id: 1)
DeviceCurrentState.create(key: "VideoSource2", value: "Blu-ray Player", device_id: 1)
DeviceCurrentState.create(key: "VideoSource3", value: "Room PC", device_id: 1)

DeviceCurrentState.create(key: "Online", value: "true", device_id: 2)
DeviceCurrentState.create(key: "Power Is On", value: "true", device_id: 2)
DeviceCurrentState.create(key: "Error State", value: "false", device_id: 2)

DeviceCurrentState.create(key: "Online", value: "true", device_id: 3)

DeviceCurrentState.create(key: "Online", value: "true", device_id: 4)
DeviceCurrentState.create(key: "Power Is On", value: "true", device_id: 4)
DeviceCurrentState.create(key: "Error State", value: "false", device_id: 4)

Device.create!(name: "Room", description: "to keep states for the room", room_id: 2)
Device.create!(name: "Projector 1", description: "asset", room_id: 2)
Device.create!(name: "Touch Panel", description: "asset", room_id: 2)

DeviceState.create(key: "Ceiling Mic Signal", value: "false", device_id: 5)
DeviceState.create(key: "WL Mic Signal", value: "true", device_id: 5)
DeviceState.create(key: "Mic Volume", value: "3", device_id: 5)
DeviceState.create(key: "Source Volume", value: "10", device_id: 5)
DeviceState.create(key: "Current Source 1", value: "1", device_id: 5)
DeviceState.create(key: "VideoSource1", value: "Document Camera", device_id: 5)
DeviceState.create(key: "VideoSource2", value: "Blu-ray Player", device_id: 5)
DeviceState.create(key: "VideoSource3", value: "Room PC", device_id: 5)

DeviceState.create(key: "Online", value: "true", device_id: 6)
DeviceState.create(key: "Power Is On", value: "true", device_id: 6)
DeviceState.create(key: "Error State", value: "false", device_id: 6)

DeviceState.create(key: "Online", value: "true", device_id: 7)

DeviceState.create(key: "Ceiling Mic Signal", value: "false", device_id: 5)
DeviceState.create(key: "WL Mic Signal", value: "true", device_id: 5)
DeviceState.create(key: "Mic Volume", value: "3", device_id: 5)
DeviceState.create(key: "Source Volume", value: "10", device_id: 5)
DeviceState.create(key: "Current Source 1", value: "1", device_id: 5)
DeviceState.create(key: "VideoSource1", value: "Document Camera", device_id: 5)
DeviceState.create(key: "VideoSource2", value: "Blu-ray Player", device_id: 5)
DeviceState.create(key: "VideoSource3", value: "Room PC", device_id: 5)

DeviceState.create(key: "Online", value: "true", device_id: 6)
DeviceState.create(key: "Power Is On", value: "true", device_id: 6)
DeviceState.create(key: "Error State", value: "false", device_id: 6)

DeviceState.create(key: "Online", value: "true", device_id: 7)

Device.create!(name: "Room", description: "to keep states for the room", room_id: 3)
Device.create!(name: "Room", description: "to keep states for the room", room_id: 4)
Device.create!(name: "Room", description: "to keep states for the room", room_id: 5)
Device.create!(name: "Room", description: "to keep states for the room", room_id: 6)
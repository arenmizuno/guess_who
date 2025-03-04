# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

# Create two users with emails
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password',  # Make sure to replace this with a secure password
  password_confirmation: 'password'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Create some characters (replace with your own character data)
characters = [
  { name: 'Cat', created_by: user1.id, photo: 'cat.png' },
  { name: 'Drake', created_by: user1.id, photo: 'driz.jpeg' },
  { name: 'Jude Bellingham', created_by: user2.id, photo: 'jude.jpg' },
  { name: 'Justin Bieber', created_by: user2.id, photo: 'justin.jpeg' },
  { name: 'Kevin', created_by: user1.id, photo: 'kevin.jpg' },
  { name: 'Kid Laroi', created_by: user1.id, photo: 'kidlaroi.avif' },
  { name: 'Mbappe', created_by: user2.id, photo: 'mbappe.jpg' },
  { name: 'Neymar', created_by: user2.id, photo: 'ney.jpeg' },
  { name: 'Nice Guy', created_by: user1.id, photo: 'niceguy.jpg' },
  { name: 'Cristiano Ronaldo', created_by: user1.id, photo: 'ron.webp' },
  { name: 'Bukayo Saka', created_by: user2.id, photo: 'saka.webp' },
  { name: 'Taylor Swift', created_by: user2.id, photo: 'taylor.png' },
  { name: 'Travis Scott', created_by: user1.id, photo: 'trav.webp' },
  { name: 'Vinicius Jr', created_by: user1.id, photo: 'vini.jpeg' },
  { name: 'Jayson Tatum', created_by: user1.id, photo: 'jayson.webp' },
  { name: 'LeBron James', created_by: user1.id, photo: 'lebron.webp' },
  { name: 'Shai Gilgeous-Alexander', created_by: user1.id, photo: 'shai.webp' },
]

# Create the characters and attach photos
characters.each do |character_data|
  character = Character.create!(name: character_data[:name], created_by: character_data[:created_by])
  
  # Attach the photo to the character (assuming the images are in 'app/assets/images/characters/')
  photo_path = Rails.root.join('app', 'assets', 'images', 'characters', character_data[:photo])
  
  if File.exist?(photo_path)
    character.photo.attach(io: File.open(photo_path), filename: character_data[:photo])
  else
    puts "Image file not found: #{character_data[:photo]}"
  end
end

puts "Seeded users and characters with photos successfully!"

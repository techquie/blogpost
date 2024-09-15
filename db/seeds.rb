# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create(name: 'Super Admin', role: 'super_admin', password: '123456', password_confirmation: '123456', active: true)
Story.create(title: 'THE WINDOW', content: "On a windy winter morning, a woman looked out of the window.The only thing she saw, a garden. A smile spread across her face as she spotted Maria, her daughter, in the middle of the garden enjoying the weather. It started drizzling. Maria started dancing joyfully.She tried to wave to her daughter, but her elbow was stuck, her arm hurt, her smile turned upside down. Reality came crashing down as the drizzle turned into a storm. Maria's murdered corpse consumed her mind.On a windy winter morning, a woman looked out of the window of her jail cell.", user: User.first, published: true)
Story.create(title: 'Thirsty Crow', content: "The Thirsty Crow moral of the story is “Where there is a will, there is a way.” A very profound saying which means if we are willing to find a solution, we will always find it around. To not lose hope in the most difficult times and to keep working towards our goal is what we learn from the smart crow. He flew across the forest, faced all the challenges, and did not give up. He also teaches us to ‘Never Give Up!’ because if we keep our focus on what we want to achieve, we will eventually achieve it. He worked hard (putting each pebble into the pot one by one) and was patient with his work. That led to sweet outcomes. As the clever crow embarked on his quest under the scorching sun, the oppressive heat added an extra layer of challenge to his pursuit of water. However, as he neared triumph, a subtle shift occurred. A gentle breeze whispered through the leaves, teaching us that nature rewards our hard work in unexpected, smaller ways.", user: User.first, published: true)

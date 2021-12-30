require "httparty"
require "json"

readmeFile = File.read("./README.md")
contentFile = File.read("./PreMiD/content.txt")

baseURL = "https://discord.com/api/v9"
matched = file.match(/([a-z]{2,32})[#][0-9]{4}/i)[0]

define_method :fetchUser do
    response = HTTParty.get("#{baseURL}/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

define_method :fetchContent do
    response = HTTParty.get("http://api.github.com/graphql", 
        :headers => {
          "Authorization" => ENV["GITHUB"]
        },
        :body => %{
          query {
            repository(owner: "PreMiD", name: "Presences") {
              discussion(4658) {
                body
              }
            }
          }
       })

    return JSON.parse(response.body)
end

user = fetchUser()
username = user["username"] << "#" << user["discriminator"]

replaced = readme.gsub(matched, username)

if (matched == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", replaced)
    exec(File.read(File.join(__dir__, "update.sh")))
end

content = fetchContent()

if (content == contentFile)
    puts "No action needed - content is still the same."
else
    File.write("./PreMiD/content.txt", content)
    exec(File.read(File.join(__dir__, "update.sh")))
end

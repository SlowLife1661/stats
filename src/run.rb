require "httpx"
require "json"

readmeFile = File.read("./README.md")
contentFile = File.read("./data/content.md")

baseURL = "https://discord.com/api/v9"
matched = readmeFile.match(/([a-z]{2,32})[#][0-9]{4}/i)[0]

define_method :fetchUser do
    response = HTTPX.get("#{baseURL}/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

define_method :fetchContent do
    response = HTTPX.post("https://api.github.com/graphql",
        :headers => {
          "Authorization" => "Bearer #{ENV["GITHUB"]}"
        },
        :body => JSON.generate({
          :query => %{{
            repository(owner: "PreMiD", name: "Presences") {
              discussion(number: 4658) {
                body
              }
            }
          }
        }
    }))

    return JSON.parse(response.body)
end

user = fetchUser()
username = user["username"] << "#" << user["discriminator"]

replaced = readmeFile.gsub(matched, username)

if (matched == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", replaced)
    exec(File.read(File.join(__dir__, "update.sh")))
end

content = fetchContent()["data"]["repository"]["discussion"]["body"]

if (content == contentFile)
    puts "No action needed - content is still the same."
else
    File.write("./data/content.md", content)
    exec(File.read(File.join(__dir__, "update.sh")))
end

import fetch from "node-fetch";
import fs from "fs";

const beseURL = "https://discord.com/api/v9/users/374905512661221377";
const file = fs.readFileSync("./README.md").toString("utf8");
const matchedUsername = file.match(/([a-z]{2,})[#][0-9]{4}/i)[0];

const fetchUser = async () => {
  const response: {
    username: string;
    discriminator: string;
  } = await (
    await fetch(beseURL, {
      method: "GET",
      headers: {
        Authorization: process.env.DISCORD_TOKEN,
      },
    })
  ).json();

  return response;
};

fetchUser().then((user) => {
  const replaced = file.replace(
    matchedUsername,
    `${user.username}#${user.discriminator}`
  );
  fs.writeFileSync("./README.md", replaced);

  console.log("All done!");
});

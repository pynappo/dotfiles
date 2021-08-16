/* petpet, a Powercord Plugin to create petting gifs
 * Copyright 2021 Vendicated
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const { Plugin } = require("powercord/entities");
const { channels, getModule, getModuleByDisplayName } = require("powercord/webpack");
const { open: openModal } = require("powercord/modal");
const { readFileSync } = require("fs");
const { join } = require("path");

const GifEncoder = require("./gifencoder");

const defaults = {
    resolution: 128,
    delay: 20
};

const emoteRegex = /<?(a)?:?(\w{2,32}):(\d{17,19})>?/;

module.exports = class PetPet extends Plugin {
    async startPlugin() {
        const { pushFiles } = await getModule(["pushFiles"]);
        const UploadModal = await getModuleByDisplayName("UploadModal");
        const { getUser } = await getModule(["getUser"]);

        const res = result => ({ result });

        powercord.api.commands.registerCommand({
            command: "petpet",
            aliases: ["patpat"],
            description: "Generate a pet gif",
            usage: "<IMAGE_URL | EMOTE | UserID / Mention> [FILE_NAME - default pet.gif] [DELAY - default 20)] [RESOLUTION - default 128]",
            executor: async ([url, fileName, delay, resolution]) => {
                if (!url) return res(`give me an image or user to pet dummy`);

                if (!url.startsWith("http")) {
                    const emoteMatch = emoteRegex.exec(url);
                    if (emoteMatch) {
                        url = `https://cdn.discordapp.com/emojis/${emoteMatch[3]}.${emoteMatch[1] ? "gif" : "png"}`;
                    } else {
                        const id = url.match(/\d{17,19}/)?.[0];
                        if (!id) return res("Please specify either a valid url (must start with http(s)), a user or an emote");
                        const user = await getUser(id).catch(() => void 0);
                        if (!user) return res("That user doesn't exist");
                        url = user.getAvatarURL();
                        if (!url) return res("That user doesn't have an avatar");
                    }
                }

                const av = await this.loadImage(url, false).catch(() => void 0);
                if (!av) return res("Something went wrong while loading that image");

                const options = {};
                if (delay !== undefined) {
                    if (typeof (delay = this.parseInt(delay, "delay")) === "string") return res(delay);
                    options.delay = delay;
                }
                if (resolution !== undefined) {
                    if (typeof (resolution = this.parseInt(resolution, "resolution")) === "string") return res(resolution);
                    options.resolution = resolution;
                }

                let buf;
                try {
                    buf = await this.petpet(av, options);
                } catch (error) {
                    this.error(error);
                    return res("Sorry, something went wrong. Check the console for more info");
                }

                let name;
                if (fileName) {
                    if (!fileName.endsWith(".gif")) fileName += ".gif";
                    name = fileName;
                } else {
                    name = "petpet.gif";
                }
                const file = new File([buf], name, { type: "image/gif" });
                pushFiles({ channelId: channels.getChannelId(), files: [file] });
                openModal(UploadModal);
            }
        });
    }

    pluginWillUnload() {
        powercord.api.commands.unregisterCommand("petpet");
    }

    parseInt(str, type) {
        const n = parseInt(str);
        if (isNaN(n)) return `${type} must be a number, received \`${str}\``;
        if (n <= 0) return `${type} must be bigger than 0, received \`${str}\``;
        return n;
    }

    loadImage(src, local) {
        return new Promise((resolve, reject) => {
            const img = new Image();
            img.onload = () => {
                if (local) URL.revokeObjectURL(src);
                resolve(img);
            };
            img.onerror = reject;
            if (local) {
                try {
                    const buf = readFileSync(src);
                    const blob = new Blob([buf], { type: "image/gif" });
                    src = URL.createObjectURL(blob);
                } catch (err) {
                    reject(err);
                }
            } else img.crossOrigin = "Anonymous";
            img.src = src;
        });
    }

    // Based on https://github.com/aDu/pet-pet-gif, licensed under ISC
    async petpet(avatar, options) {
        if (!this.frames)
            this.frames = await Promise.all(
                Array(10)
                    .fill(null)
                    .map((_, i) => {
                        const filename = join(__dirname, "frames", `pet${i}.gif`);
                        return this.loadImage(filename, true);
                    })
            );

        const FRAMES = this.frames.length;

        options = { ...defaults, ...options };
        const encoder = new GifEncoder(options.resolution, options.resolution);

        encoder.start();
        encoder.setRepeat(0);
        encoder.setDelay(options.delay);
        encoder.setTransparent();

        const canvas = document.createElement("canvas");
        canvas.width = canvas.height = options.resolution;
        const ctx = canvas.getContext("2d");

        for (let i = 0; i < FRAMES; i++) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            const j = i < FRAMES / 2 ? i : FRAMES - i;

            const width = 0.8 + j * 0.02;
            const height = 0.8 - j * 0.05;
            const offsetX = (1 - width) * 0.5 + 0.1;
            const offsetY = 1 - height - 0.08;

            ctx.drawImage(avatar, options.resolution * offsetX, options.resolution * offsetY, options.resolution * width, options.resolution * height);
            ctx.drawImage(this.frames[i], 0, 0, options.resolution, options.resolution);

            encoder.addFrame(ctx);
        }

        encoder.finish();
        return encoder.out.getData();
    }
};

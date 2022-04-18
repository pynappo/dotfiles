/**
 * @name FileViewer
 * @author AGreenPig
 * @updateUrl https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js
 * @authorLink https://github.com/TheGreenPig
 * @source https://github.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js
 * @invite JsqBVSCugb
 */
module.exports = (() => {
	const config = {
		info: {
			name: "FileViewer",
			authors: [
				{
					name: "AGreenPig",
					discord_id: "427179231164760066",
					github_username: "TheGreenPig",
				},
			],
			version: "1.0.4",
			description: "View Pdf and other files directly in Discord.",
			github_raw:
				"https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js",
		},
		changelog: [
			{
				title: "Added",
				type: "added",
				items: [
					"Support for some 3D model filetypes (stl, obj, vf, vsj, vsb, 3mf)",
					"odt files",
				],
			},
		],
	};
	const css = `
		.FileViewerEmbed {
			resize: both; 
			overflow: auto;
			padding: 10px;
			max-width: 100%;
			min-width: 100px;
			max-height: 80vh;
			min-height: 100px;
		}
	`;
	return !global.ZeresPluginLibrary
		? class {
				constructor() {
					this._config = config;
				}
				getName() {
					return config.info.name;
				}
				getAuthor() {
					return config.info.authors.map((a) => a.name).join(", ");
				}
				getDescription() {
					return config.info.description;
				}
				getVersion() {
					return config.info.version;
				}
				load() {
					BdApi.showConfirmationModal(
						"Library Missing",
						`The library plugin needed for ${config.info.name} is missing. Please click Download Now to install it.`,
						{
							confirmText: "Download Now",
							cancelText: "Cancel",
							onConfirm: () => {
								require("request").get(
									"https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js",
									async (error, response, body) => {
										if (error)
											return require("electron").shell.openExternal(
												"https://betterdiscord.net/ghdl?url=https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js"
											);
										await new Promise((r) =>
											require("fs").writeFile(
												require("path").join(
													BdApi.Plugins.folder,
													"0PluginLibrary.plugin.js"
												),
												body,
												r
											)
										);
									}
								);
							},
						}
					);
				}
				start() {}
				stop() {}
		  }
		: (([Plugin, Api]) => {
				const plugin = (Plugin, Library) => {
					const { Patcher, React, Settings } = { ...Api, ...BdApi };
					const { SettingPanel, Switch, Textbox } = Settings;

					const Attachment = BdApi.findModule(
						(m) => m.default?.displayName === "Attachment"
					);
					const TooltipContainer =
						BdApi.findModuleByProps("TooltipContainer").TooltipContainer;
					//Thanks Dastan21 for the icons <3
					const ShowIcon = React.createElement("path", {
						fill: "currentColor",
						d: "M113,37.66667c-75.33333,0 -103.58333,75.33333 -103.58333,75.33333c0,0 28.25,75.33333 103.58333,75.33333c75.33333,0 103.58333,-75.33333 103.58333,-75.33333c0,0 -28.25,-75.33333 -103.58333,-75.33333zM113,65.91667c25.99942,0 47.08333,21.08392 47.08333,47.08333c0,25.99942 -21.08392,47.08333 -47.08333,47.08333c-25.99942,0 -47.08333,-21.08392 -47.08333,-47.08333c0,-25.99942 21.08392,-47.08333 47.08333,-47.08333zM113,84.75c-15.60204,0 -28.25,12.64796 -28.25,28.25c0,15.60204 12.64796,28.25 28.25,28.25c15.60204,0 28.25,-12.64796 28.25,-28.25c0,-15.60204 -12.64796,-28.25 -28.25,-28.25z",
					});
					const HideIcon = React.createElement("path", {
						fill: "currentColor",
						d: "M37.57471,28.15804c-3.83186,0.00101 -7.28105,2.32361 -8.72295,5.87384c-1.4419,3.55022 -0.58897,7.62011 2.15703,10.29267l16.79183,16.79183c-18.19175,14.60996 -29.9888,32.52303 -35.82747,43.03711c-3.12633,5.63117 -3.02363,12.41043 0.03678,18.07927c10.87625,20.13283 42.14532,66.10058 100.99007,66.10058c19.54493,0 35.83986,-5.13463 49.36394,-12.65365l19.31152,19.31152c2.36186,2.46002 5.8691,3.45098 9.16909,2.5907c3.3,-0.86028 5.87708,-3.43736 6.73736,-6.73736c0.86028,-3.3 -0.13068,-6.80724 -2.5907,-9.16909l-150.66666,-150.66667c-1.77289,-1.82243 -4.20732,-2.8506 -6.74984,-2.85075zM113,37.66667c-11.413,0 -21.60375,1.88068 -30.91683,4.81869l24.11182,24.11182c2.23175,-0.32958 4.47909,-0.6805 6.80501,-0.6805c25.99942,0 47.08333,21.08392 47.08333,47.08333c0,2.32592 -0.35092,4.57326 -0.6805,6.80501l32.29623,32.29623c10.1135,-11.22467 17.51573,-22.61015 21.94157,-30.18115c3.3335,-5.68767 3.32011,-12.67425 0.16553,-18.4655c-11.00808,-20.27408 -42.2439,-65.78792 -100.80615,-65.78792zM73.77002,87.08577l13.77555,13.77556c-1.77707,3.67147 -2.79557,7.77466 -2.79557,12.13867c0,15.60342 12.64658,28.25 28.25,28.25c4.364,0 8.46719,-1.01851 12.13867,-2.79557l13.79395,13.79395c-9.356,6.20362 -21.03043,9.17606 -33.4733,7.24642c-19.75617,-3.06983 -35.88427,-19.19794 -38.9541,-38.9541c-1.92879,-12.43739 1.0665,-24.10096 7.26481,-33.45491z",
					});
					const WarningIcon = React.createElement("path", {
						fill: "red",
						d: "M12 0c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm-1.351 6.493c-.08-.801.55-1.493 1.351-1.493s1.431.692 1.351 1.493l-.801 8.01c-.029.282-.266.497-.55.497s-.521-.215-.55-.498l-.801-8.009zm1.351 12.757c-.69 0-1.25-.56-1.25-1.25s.56-1.25 1.25-1.25 1.25.56 1.25 1.25-.56 1.25-1.25 1.25z",
					});

					const officeExtensions = [
						"ppt",
						"pptx",
						"doc",
						"docx",
						"xls",
						"xlsx",
						"odt",
					];
					const googleExtensions = ["pdf"];
					const objectExtensions = ["stl", "obj", "vf", "vsj", "vsb", "3mf"];
					class FileViewerButton extends React.Component {
						state = { displayingFile: false };
						render() {
							let button = React.createElement(
								TooltipContainer,
								{ text: this.state.displayingFile ? "Hide File" : "Show File" },
								React.createElement(
									"svg",
									{
										class: "downloadButton-2HLFWN",
										width: "24",
										height: "24",
										viewBox: "0 0 226 226",
										onClick: (e) => {
											if (e.shiftKey) {
												window.open(this.props.url, "_blank").focus();
												return;
											}

											this.setState({
												displayingFile: !this.state.displayingFile,
												url: this.state.url,
											});
											let attachmentElement = e.target.closest(
												`div[class^="messageAttachment"]`
											);
											if (!this.state.displayingFile) {
												let embed = document.createElement("iframe");
												embed.setAttribute("class", "FileViewerEmbed");
												embed.setAttribute("src", this.props.url);
												embed.setAttribute("width", this.props.width);
												embed.setAttribute("height", this.props.height);

												attachmentElement.appendChild(embed);
											} else {
												let embed = attachmentElement.lastChild;
												if (embed) embed.remove();
											}
										},
									},
									this.state.displayingFile ? HideIcon : ShowIcon
								)
							);
							return button;
						}
					}
					return class FileViwer extends Plugin {
						start() {
							this.settings = this.loadSettings({
								forceProvider: false,
							});
							BdApi.injectCSS(config.info.name, css);

							this.patchAttachments();
						}
						patchAttachments() {
							Patcher.after(
								config.info.name,
								Attachment,
								"default",
								(_, __, ret) => {
									if (
										ret.props?.children?.length === 0 ||
										!ret.props.children[2]?.props?.href
									) {
										return;
									}
									const fileUrl = ret.props.children[2]?.props?.href;

									let isGoogleExtension = googleExtensions.some((e) => {
										return fileUrl.endsWith(e);
									});
									let isOfficeExtension = officeExtensions.some((e) => {
										return fileUrl.endsWith(e);
									});
									let isOjectExtension = objectExtensions.some((e) => {
										return fileUrl.endsWith(e);
									});
									if (
										!isGoogleExtension &&
										!isOfficeExtension &&
										!isOjectExtension
									) {
										return;
									}

									let googleUrl = `https://drive.google.com/viewerng/viewer?embedded=true&url=${fileUrl}`;
									let officeUrl = `https://view.officeapps.live.com/op/view.aspx?src=${fileUrl}`;
									let objectUrl = `https://www.viewstl.com/?embedded&url=${fileUrl}`;
									let useGoogleProvider =
										this.settings.forceProvider || isGoogleExtension;

									let button = React.createElement(FileViewerButton, {
										displayingFile: false,
										url: isOjectExtension
											? objectUrl
											: useGoogleProvider
											? googleUrl
											: officeUrl,
										width: "100%",
										height: "600px",
									});
									//check for supported file type

									//in bytes--> 10mb
									let fileTooBig = 10485760 < __[0].size;
									let warningIcon = null;
									if (fileTooBig) {
										warningIcon = React.createElement(
											TooltipContainer,
											{
												text: `This file is over 10mb! FileViewer might not be able to preview this file.`,
											},
											React.createElement(
												"svg",
												{
													width: "24",
													height: "24",
													viewBox: "0 0 24 24",
													style: { paddingLeft: "10px" },
												},
												WarningIcon
											)
										);
									}
									ret.props.children = [
										...ret.props.children,
										button,
										warningIcon,
									];
								}
							);
						}
						getSettingsPanel() {
							//build the settings panel
							return SettingPanel.build(
								() => this.saveSettings(this.settings),
								new Switch(
									"Force Google provider",
									`By default all office related files will be displayed by the Office Web Apps Viewer, 
									all other files the Google Docs Viewer to allow for the best overall experience. 
									If you only want to use the Google Docs Viewer, turn this setting on (some office files might not be displayed correctly).`,
									this.settings.forceProvider,
									(i) => {
										this.settings.forceProvider = i;
									}
								)
							);
						}
						stop() {
							Patcher.unpatchAll(config.info.name);
							BdApi.clearCSS(config.info.name);
						}
					};
				};
				return plugin(Plugin, Api);
		  })(global.ZeresPluginLibrary.buildPlugin(config));
})();

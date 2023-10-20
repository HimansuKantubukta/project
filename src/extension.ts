'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below


import * as vscode from 'vscode';

import * as peggy from "peggy";
import path = require('path');

const fs = require('fs');



// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {

	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('Congratulations, your extension "pmf-ext-v1" is now active!');

	let parser: peggy.Parser;
	let srcGrammer: any;
	let peggyParserOptions: any;
	let parserOutputFolderPath: any;

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with registerCommand
	// The commandId parameter must match the command field in package.json
	let disposable = vscode.commands.registerCommand('pmf-ext-v1.parseGrammar', async () => {
		// The code you place here will be executed every time your command is executed
		// Display a message box to the user
		// vscode.window.showInformationMessage('Hello from pmf-ext-v1!');
		// vscode.window.showInformationMessage('Use this command to parse an open Grammer in Editor, Either select a Portion of grammer or will Parse the whole Grammer File..!');

		// Get the active text editor
		const editor = vscode.window.activeTextEditor;

		if (editor) {
			const document = editor.document;

			const selection = editor.selection;
			if (selection.isEmpty) {
				vscode.window.showInformationMessage('No Selection Made, Parsing the whole Doc.');
				srcGrammer = document.getText();
			} else {
				srcGrammer = document.getText(selection);
			}
			// console.log('srcGrammar:::'+srcGrammer);

			try {

				parser = peggy.generate(srcGrammer, {
					cache: true, error: function c(...cl) {
						console.log('Error from error Function.....!');
						console.error(cl);
						vscode.window.showErrorMessage('There was an error Parsing the current Grammar File!..');
					}
				},);

				if (parser) {
					vscode.window.showInformationMessage('PMF Peggy Parse Successfull!...');
				}

			} catch (error) {
				vscode.window.showErrorMessage('There was an error Parsing the current Grammar File!..');
				console.error('There was an error...!');
				console.error(error);
			}

			// Get the word within the selection

			// const reversed = word.split('').reverse().join('');
			// editor.edit(editBuilder => {
			// 	editBuilder.replace(selection, reversed);
			// });
		} else {
			vscode.window.showWarningMessage('Please open a Grammer File for Parsing...!');
		}

	});

	let disposable1 = vscode.commands.registerCommand('pmf-ext-v1.loadParserOptions', async () => {

		if (!parser) {
			vscode.window.showWarningMessage('The Peggy Grammaer is not Initated, Please load the Grammer First..!');
			return;
		}

		// Get the active text editor
		const editor = vscode.window.activeTextEditor;

		if (editor) {
			const document = editor.document;
			const selection = editor.selection;
			try {

				if (selection.isEmpty) {
					vscode.window.showInformationMessage('No Selection Made, Parsing the whole Doc.');
					peggyParserOptions = JSON.parse(document.getText());
				} else {
					peggyParserOptions = JSON.parse(document.getText(selection));
				}
				console.log(peggyParserOptions.debug);
				if (peggyParserOptions) {
					vscode.window.showInformationMessage('Loading Parser Options File.. Successfull!');
				}

			} catch (error) {

				console.error('There was an error initializing the Options Object...!');
				console.error(error);
			}

		} else {
			//peggyParserOptions = {};
			vscode.window.showWarningMessage('Please open a Peggy Parser Options File for Parsing!..');
		}


	});

	let disposable2 = vscode.commands.registerCommand('pmf-ext-v1.executeParserInline', async () => {

		if (!parser) {
			vscode.window.showWarningMessage('The Peggy Grammaer is not Initated, Please load the Grammer First..!');
			return;
		}

		if (!peggyParserOptions || Object.keys(peggyParserOptions).length === 0) {
			vscode.window.showWarningMessage('Using Empty Parser Options...');
			peggyParserOptions = {};
		}


		// Get the active text editor
		const editor = vscode.window.activeTextEditor;
		let sqlSource;

		if (editor) {
			const document = editor.document;
			const selection = editor.selection;
			try {

				if (selection.isEmpty) {
					vscode.window.showInformationMessage('No Selection Made, Please highlight the Text that needs to Be Parsed and Try Again..!');
					return;	
				} 
				
				sqlSource = document.getText(selection);
				
				console.log('Selected Input Source : ' + sqlSource);
				console.log('Parser Options ::' + JSON.stringify(peggyParserOptions));

				const output = await parser.parse(sqlSource, peggyParserOptions);
				if (output) {

					editor.edit(editBuilder => {
						editBuilder.replace(selection, output);
						// if (selection.isEmpty) {
						// 	editBuilder.insert(editor.selection.active, '\nParser Output >>>\n' + output);
						// } else {
						// 	editBuilder.insert(selection.end, '\nParser Output >>>\n' + output);
						// }

					});
					vscode.window.showInformationMessage('Execute In-Line parser Success!!!.');

				}



			} catch (error) {
				vscode.window.showErrorMessage('Error executing In-Line Parser');

				console.error('Error executing In-Line Parser');
				console.debug(error);
			}

		} else {
			vscode.window.showWarningMessage('Please open a Peggy Parser Options File for Parsing!..');
		}


	});

	let disposable3 = vscode.commands.registerCommand('pmf-ext-v1.selectOutputFolder', async () => {

		const editor = vscode.window.activeTextEditor;



		const options: vscode.OpenDialogOptions = {
			canSelectMany: false,
			openLabel: 'Select Folder',
			canSelectFiles: false,
			canSelectFolders: true,
			title: 'Select Output Folder for Peggy Parser'

		};

		vscode.window.showOpenDialog(options).then(fileUri => {
			if (fileUri && fileUri[0]) {
				const filepath = editor?.document?.fileName;

				console.log('Selected folder : ' + fileUri[0].fsPath);
				//console.log('Selected folder path : ' + fileUri[0].path);

				//console.log('Input FileName : '+filepath?.substring(filepath.lastIndexOf('\\')));
				//console.log('Input FileName URI : '+editor?.document.uri);
				parserOutputFolderPath = fileUri[0].fsPath;



			}
		});

	});

	let disposable4 = vscode.commands.registerCommand('pmf-ext-v1.executeParser', async () => {
		if (!parser) {
			vscode.window.showWarningMessage('The Peggy Grammaer is not Initated, Please load the Grammer First..!');
			return;
		}

		if (!peggyParserOptions || Object.keys(peggyParserOptions).length === 0) {
			vscode.window.showWarningMessage('Using Empty Parser Options...');
			peggyParserOptions = {};
		}

		// Get the active text editor
		const editor = vscode.window.activeTextEditor;
		let sqlSource;

		if (editor) {
			const document = editor.document;
			const selection = editor.selection;
			try {

				if (selection.isEmpty) {
					vscode.window.showInformationMessage('No Selection Made, Parsing the whole Doc.');
					sqlSource = document.getText();
				} else {
					sqlSource = document.getText(selection);
				}
				console.log('Selected Input Source : ' + sqlSource);
				console.log('Parser Options ::' + JSON.stringify(peggyParserOptions));

				const output = await parser.parse(sqlSource, peggyParserOptions);
				if (output) {
					vscode.window.showInformationMessage('Execute Parser Success!!!.');
					// Check for Output Folder selection
					if (!parserOutputFolderPath) {
						let outputPath = editor.document.uri.fsPath;
						console.log('outputPath' + outputPath);
						let inpfilename = outputPath.substring(outputPath.lastIndexOf('\\') + 1);
						console.log('inpfilename' + inpfilename);
						let outputFileName = inpfilename.replace('.', '_out.');
						console.log('outputFileName:' + outputFileName);
						console.log('outputPath:' + outputPath);
						parserOutputFolderPath = outputPath.replace(inpfilename, outputFileName);
						console.log('parserOutputFolderPath:' + parserOutputFolderPath);
						try {
							const fsPromises = fs.promises;
							await fsPromises.writeFile(parserOutputFolderPath, output, { create: true, overwrite: true });
							console.log('Wrote File ');
						} catch (error) {
							console.error('There was an Error writing to File...' + error);
							vscode.window.showErrorMessage('There was an Error writing to File...');
						}

						// fs_path.basename();
						//parserOutputFolderPath = editor.document.uri.fsPath.;

					} else {

						let outputPath = editor.document.uri.fsPath;
						// console.log('outputPath' + outputPath);
						let inpfilename = outputPath.substring(outputPath.lastIndexOf('\\') + 1);
						// console.log('inpfilename' + inpfilename);
						let outputFileName = inpfilename.replace('.', '_out.');
						// console.log('outputFileName:' + outputFileName);
						// console.log('outputPath:' + outputPath);
						let outputFolderPath = parserOutputFolderPath + '\\' + outputFileName;
						console.log('parserOutputFolderPath:' + outputFolderPath);
						try {
							const fsPromises = fs.promises;
							await fsPromises.writeFile(outputFolderPath, output, { create: true, overwrite: true });
							console.log('Wrote File ');
						} catch (error) {
							console.error('There was an Error writing to File...' + error);
							vscode.window.showErrorMessage('There was an Error writing to File...');
						}

					}




				} else {
					vscode.window.showWarningMessage('Execute Parser Could Not be Parsed...!');
				}



			} catch (error) {
				vscode.window.showErrorMessage('Error executing Peggy Parser');

				console.error('Error executing Peggy Parser');
				console.debug(error);
			}

		} else {
			vscode.window.showWarningMessage('Please open a Peggy Parser Options File for Parsing!..');
		}

	});

	let disposable5 = vscode.commands.registerCommand('pmf-ext-v1.reset', async () => {
		
		
		srcGrammer = {};
		peggyParserOptions = {};
		parserOutputFolderPath = {};
		vscode.window.showInformationMessage('Reset Done!.');

	});

	let disposable8 = vscode.commands.registerCommand('pmf-ext-v1.selectInputFolder', async () => {
		if (!parser) {
            vscode.window.showWarningMessage('The Peggy Grammar is not initiated. Please load the Grammar first.');
            return;
        }

       

        // Open a dialog to select a folder
        const options = {
            
            canSelectFolders: true,
            openLabel: 'Select Folder for Parsing and Updating'
        };

        vscode.window.showOpenDialog(options).then(folderUri => {
            if (folderUri && folderUri[0]) {
                const folderPath = folderUri[0].fsPath;

                // Read all files in the selected folder
                fs.readdir(folderPath, (err: any, files: any[]) => {
                    if (err) {
                        vscode.window.showErrorMessage('Error reading folder contents.');
                        return;
                    }

                    // Process each file in the folder
                    files.forEach((file: string) => {
                        const filePath = path.join(folderPath, file);

                        // Check if the file is a regular file
                        if (fs.statSync(filePath).isFile()) {
                            // Read the file content
                            fs.readFile(filePath, 'utf-8', (readErr: any, fileContent: string) => {
                                if (readErr) {
                                    vscode.window.showErrorMessage(`Error reading file: ${file}`);
                                } else {
                                    try {
                                        // Parse the content of the file
                                        const parsedContent = parser.parse(fileContent, peggyParserOptions);

                                        // Update the file with the parsed content
                                        fs.writeFile(filePath, parsedContent, 'utf-8', (writeErr: any) => {
                                            if (writeErr) {
                                                vscode.window.showErrorMessage(`Error updating file: ${file}`);
                                            } else {
                                                vscode.window.showInformationMessage(`File updated: ${file}`);
                                            }
                                        });
                                    } catch (parseErr) {
                                        vscode.window.showErrorMessage(`Error parsing file: ${file}`);
                                    }
                                }
                            });
                        }
                    });
                });
            }
        });
    });

    




	context.subscriptions.push(disposable);
	context.subscriptions.push(disposable1);
	context.subscriptions.push(disposable2);
	context.subscriptions.push(disposable3);
	context.subscriptions.push(disposable4);
	context.subscriptions.push(disposable5);
	context.subscriptions.push(disposable8);
	



}

// This method is called when your extension is deactivated
export function deactivate() {

	console.log('Your extension "pmf-ext-v1" is now de-activated!');
}

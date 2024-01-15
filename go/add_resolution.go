package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Missing files for converting. Aborting...")
		return
	}

	// Get the current working directory
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Println("Error getting current working directory:", err)
		return
	}

	// Create a directory in the current working directory if it doesn't exist
	newDirPath := filepath.Join(currentDir, "completed")
	_, err = os.Stat(newDirPath)
	if os.IsNotExist(err) {
		err = os.Mkdir(newDirPath, 0755)
		if err != nil {
			fmt.Println("Error creating directory:", err)
			return
		}
	}

	files := os.Args[1:]
	for _, file := range files {
		extension := filepath.Ext(file)
		baseName := strings.TrimSuffix(file, extension)

		// get resolution
		args := []string{"-v", "error", "-select_streams", "v:0", "-show_entries", "stream=height", "-of", "csv=s=x:p=0", file}
		cmd := exec.Command("ffprobe", args...)
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println("Error: ", err)
			return
		}

		resolution := strings.TrimRight(string(output), "\n")

		// build new file name at new destination folder with resolution added to the file name
		newFileName := filepath.Join(newDirPath, fmt.Sprintf("%s_%sp%s", baseName, resolution, extension))
		err = os.Rename(file, newFileName)
		if err != nil {
			fmt.Println("Problem renaming file name: ", err)
			return
		}
	}

	fmt.Println("Finished!")
}

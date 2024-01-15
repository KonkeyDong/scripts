package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func confirm(s string, tries int) bool {
	r := bufio.NewReader(os.Stdin)
	for ; tries > 0; tries-- {
		fmt.Printf("%s [y/n]: ", s)
		res, err := r.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}
		res = strings.TrimSpace(res)
		res = strings.ToLower(res)
		if res == "y" {
			return true
		} else if res == "n" {
			return false
		}
	}

	return false
}

func main() {
	cwd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	dirs := make([]string, 0)
	files := make([]string, 0)

	err = filepath.Walk(cwd, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() {
			if path != cwd {
				dirs = append(dirs, path)
			}
		} else {
			files = append(files, path)
		}

		return nil
	})

	if err != nil {
		fmt.Println(err)
	}

	// fmt.Println("dirs: ", dirs)
	// fmt.Println()
	// fmt.Println("files: ", files)

	if confirm(fmt.Sprintf("Confirm deleting all files from [%s]?", cwd), 1) {
		for _, file := range files {
			fmt.Println("Shredding file: ", file)

			args := []string{"-u", "-z", file}
			cmd := exec.Command("shred", args...)
			_, err := cmd.CombinedOutput()
			if err != nil {
				fmt.Println("Error:", err)
				return
			}
		}

		// we can't use RemoveAll on cwd because we want to KEEP
		// the directory that is containing the files to shred.
		for _, dir := range dirs {
			fmt.Println("Removing directory: ", dir)
			err = os.Remove(dir)
			if err != nil {
				fmt.Println("Error removing dirs: ", err)
				return
			}
		}
	}

	fmt.Println("Finished!")
}

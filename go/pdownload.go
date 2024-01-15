package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strings"
	"sync"
)

// download using yt-dlp as the main executable.
// the line arg contains the arguments to yt-dlp.
func downloadURL(line string, counter int, upperLimit int, wg *sync.WaitGroup) {
	defer wg.Done()

	args := strings.Fields(line)

	// check if file is already written/downloaded
	_, err := os.Stat(args[2])
	if !os.IsNotExist(err) {
		return
	}

	fmt.Println(fmt.Sprintf("downloading %s... [%d of %d]", args[0], counter, upperLimit))

	cmd := exec.Command("yt-dlp", args...)
	_, err = cmd.CombinedOutput()
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println(fmt.Sprintf("Finished downloading %s! [%d of %d]", args[0], counter, upperLimit))
}

// Lines being an array where each element is like so separated by space
// <URL> -o <output_name.mp4>
func downloadURLs(lines []string, concurrentDownloads int) {
	var wg sync.WaitGroup
	argLineCh := make(chan string)

	counter := 0

	// Create goroutines for concurrent downloads
	for i := 0; i < concurrentDownloads; i++ {
		go func() {
			for line := range argLineCh {
				wg.Add(1)
				counter += 1
				downloadURL(line, counter, len(lines), &wg)
			}
		}()
	}

	// Send URLs to the goroutines through the channel
	for _, line := range lines {
		argLineCh <- line
	}

	// Close the channel to signal that no more URLs will be sent
	close(argLineCh)

	// Wait for all goroutines to finish
	wg.Wait()
}

func main() {
	// need 1 arg not including the package name
	if len(os.Args) < 2 {
		fmt.Println("Missing file containing URL and options. Aborting...")
		return
	}

	// Open the file
	file, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	// open a file and add everyline to a slice
	var fileContent []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		fileContent = append(fileContent, line)
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		return
	}

	// get and display the # of CPUs and use that for the number of
	// open channels for parallel downloading.
	numberOfCPUs := runtime.NumCPU()
	fmt.Println("Number of CPUs: ", numberOfCPUs)

	downloadURLs(fileContent, numberOfCPUs)
}

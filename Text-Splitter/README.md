# Text-Splitter
A script to take a single file and split it into two text sources by specifying a word. Anything before the specified word will be put into the first text source, anything after the word will be put into the second text source.

One example use case for this is that if you have the "Now Playing" music track written to a file in the form "Artist - Song", you can use this with a delimiter of "-" to put the Artist and the Song into two separate text sources.

# Parameters

- **Input Path** - The path to the file containing the text to be split
- **Delimiter Word** - The word to split on
- **Output Source 1** - The name of the output text source that should contain everything *before* the delimiter word
- **Output Source 2** - The name of the output text source that should contain everything *after* the delimiter word
- **Interval (ms)** - How frequently the text sources update from the file, in milliseconds. Lower will update more frequently, but have a greater performance impact

# Troubleshooting

*My text sources don't contain the text after installing the script*
- Check to make sure in the properties for the two output text sources that 'Read from file' is NOT checked
- Check that the text source names are entered into the script parameters EXACTLY as they are set in the Sources list

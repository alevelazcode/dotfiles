
# Define a function called 'copy_to_clipboard'
function copy_to_clipboard
    set -l input $argv

    # Check if input is empty
    if test -z "$input"
        echo "No input provided."
        return 1
    end

    # Check if the input is a file that exists
    if test -f "$input"
        set input (cat $input)
    end

    # Detect the operating system
    if test (uname) = "Darwin"
        # macOS
        echo -n $input | pbcopy
    else if type -q xclip
        # Linux with xclip
        echo -n $input | xclip -selection clipboard
    else
        echo "pbcopy or xclip not available. Cannot copy to clipboard."
        return 1
    end
end

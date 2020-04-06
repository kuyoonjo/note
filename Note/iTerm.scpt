on run argv
    if (count of argv) > 0 then
        set cmd to ""
        repeat with arg in argv
            set cmd to cmd & " " & (arg as text) & " "
        end repeat
        set hasCmd to true
    else
        set hasCmd to false
    end if
    
    if application "iTerm" is not running then
        log "activate iTerm"
        activate application "iTerm"
    end if
    tell application "iTerm"
        activate
        tell current window
            create tab with default profile
            tell current tab
                select
                tell current session
                    if hasCmd then
                        write text cmd
                    end if
                end tell
            end tell
        end tell
    end tell
end run

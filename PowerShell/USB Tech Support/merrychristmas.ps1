function christmas-colorized {
    # ANSI escape codes
    $esc = "$([char]27)"
    $reset = "${esc}[0m"
    $red = "${esc}[91m"
    $darkRed = "${esc}[31m"
    $lightRed = "${esc}[38;5;203m"  # ANSI extended color code for a lighter red
    $green = "${esc}[92m"
    $darkGreen = "${esc}[32m"
    $yellow = "${esc}[93m"
    $golden = "${esc}[38;5;220m"  # ANSI extended color code for more golden color
    $orange = "${esc}[38;5;202m"  # ANSI extended color code for orange
    $lightOrange = "${esc}[38;5;215m"  # ANSI extended color code for light orange
    $white = "${esc}[97m"
    $fleshMorePink = "${esc}[38;5;218m"  # ANSI extended color code for more pink flesh pink
    $fleshPink = "${esc}[38;5;223m"  # ANSI extended color code for flesh pink
    $grey = "${esc}[90m"
    $darkGrey = "${esc}[38;5;240m"  # ANSI extended color code for dark grey
    $lightGrey = "${esc}[37m"  # ANSI extended color code for light grey
    $black = "${esc}[38;5;0m"  # ANSI extended color code for black
    $brickRed = "${esc}[38;5;124m"  # ANSI extended color code for brick red
    $darkBrown = "${esc}[38;5;94m"  # ANSI extended color code for dark brown
    $indigo = "${esc}[38;5;5m"  # ANSI extended color code for indigo
    $lightBlue = "${esc}[38;5;39m"  # ANSI extended color code for a lighter blue
    $blue = "${esc}[38;5;12m"  # ANSI extended color code for blue
    $flameWhite = "${esc}[38;5;229m"  # ANSI extended color code for a lighter yellow/golden color
    # ANSI escape codes for blinking
    $blink = "${esc}[5m"
    # Blinking colors
    $blinkingLightBlue = "${blink}${lightBlue}"
    $blinkingIndigo = "${blink}${indigo}"
    $blinkingRed = "${blink}${red}"
    $blinkingGreen = "${blink}${green}"
    $blinkingOrange = "${blink}${orange}"
    $blinkingWhite = "${blink}${white}"
    $blinkingYellow = "${blink}${yellow}"
    $blinkingFlameWhite = "${blink}${flameWhite}"
    $blinkingLightOrange = "${blink}${lightOrange}"
    $blinkingDarkRed = "${blink}${darkRed}"
    $blinkingGrey = "${blink}${grey}"

    # ASCII art with embedded color codes
    $christmas = @"
${red}     __,_,_,___)${reset}          ${golden}_______${reset}
${red}    (--| | |${reset}             ${golden}(--/    ),_)${reset}        ${golden},_) ${reset}
${red}       | | |  _ ,_,_${reset}        ${golden}|     |_ ,_ ' , _|_,_,_, _  ,${reset}
${red}     __| | | (/_| | (_|${reset}     ${golden}|     | ||  |/_)_| | | |(_|/_)___,${reset}
${red}    (      |___,   ,__|${reset}     ${golden}\____)  |__,           |__,${reset}

                            ${yellow}|${reset}                         ${darkGreen}_...._${reset}
                         ${yellow}\  _  /${reset}                    ${darkGreen}.::${darkBrown}o${darkGreen}:::::.${reset}
                          ${white}(\${fleshPink}o${white}/)${reset}                    ${darkGreen}.:::'''':${darkBrown}o${darkGreen}:.${reset}
                      ${yellow}---${reset}  ${white}/ \${reset}  ${yellow}---${reset}                ${darkGreen}:${darkBrown}o${darkGreen}:${red}_    _${darkGreen}:::${reset}
                           ${darkGreen}>+<${reset}                     ${darkGreen}':${red}}_>()<_{${darkGreen}:'${reset}
                          ${darkGreen}>?<%<${reset}                 ${blinkingLightOrange}@${reset}    ${golden}``'${white}//\\${golden}``'${reset}    ${blinkingLightOrange}@${reset}
                         ${darkGreen}>>>%<<+${reset}              ${blinkingLightOrange}@${reset} ${white}#     //  \\     # ${blinkingLightOrange}@${reset}
                        ${darkGreen}>%>+<?<<<${reset}           ${darkBrown}__${white}#${darkBrown}_${white}#${darkBrown}____${white}/${golden}'${white}${darkBrown}____${golden}'${white}\${darkBrown}____${white}#${darkBrown}_${white}#${darkBrown}__${reset}
                       ${darkGreen}>+>>%<<<%<<${reset}         ${darkBrown}[__________________________]${reset}
                      ${darkGreen}>%>>?<<<+<<%<${reset}         ${brickRed}|=_- .-${white}/\ /\ /\ /\${brickRed}--. =_-|${reset}
                     ${darkGreen}>+>>?<<%<<<%<<<${reset}        ${brickRed}|-_= | ${red}\ \\ \\ \\ \${brickRed} |-_=-|${reset}
                    ${darkGreen}>%>>+<<%<>+<<?<+<${reset}       ${brickRed}|_=-=| ${red}/ // // // /${brickRed} |_=-_|${reset}
      ${darkGreen}\*/          ${darkGreen}>?>>+<<%<>?><<+<%<<${reset}      ${brickRed}|=_- | ${darkGreen}``-'``-'-'``-'${brickRed}  |=_=-|${reset}
  ${red}___${darkGreen}\\U//${red}___     ${darkGreen}>+>>%><?<<+>>%><+<?<<${reset}     ${brickRed}| =_-| ${darkGrey}o${reset}          ${darkGrey}o${brickRed} |_==_|${reset}
  ${red}|${golden}\\ | | \\${red}|    ${darkGreen}>%>>?<+<<?>>%<<?<<<+<%<${reset}    ${brickRed}|=_- | ${darkGrey}!${reset}     ${blinkingGrey}(${reset}    ${darkGrey}!${brickRed} |=_==|${reset}
  ${red}| ${golden}\\| | ${darkGreen}_${white}(UU)${darkGreen}_${darkGreen}>>${golden}((${yellow}*${golden}))${darkGreen}>>?><+<?><%<<<?<+<${reset}  ${brickRed}_|-,-=| ${darkGrey}!${reset}    ${blinkingGrey})${blinkingDarkRed}.${reset}    ${darkGrey}!${brickRed} |-_-=|_${reset}
  ${red}|${golden}\ \| |${darkGreen}| ${red}/ //${darkGreen}|${blue}|${lightBlue}.${golden}*${lightBlue}.${golden}*${lightBlue}.${golden}*${lightBlue}.${blue}|${darkGreen}>>%<<+<<%>><?<<%<${reset}${brickRed}/=-_==_| ${darkGrey}!${reset} ${blinkingLightOrange}__${blinkingOrange}(${blinkingRed}:'${blinkingOrange})${blinkingLightOrange}__${reset} ${darkGrey}!${brickRed} |=_==_-\${reset}
  ${red}|${golden}\\_|${darkGreen}_${golden}|${white}&&${darkGreen}_${red}// ${darkGreen}|${blue}|${golden}*${lightBlue}.${golden}*${lightBlue}.${golden}*${lightBlue}.${golden}*${blue}|${lightRed}_${darkBrown}\\db//${lightRed}__${reset}     ${white}(\_/)${reset}${brickRed}-=__-|${darkGrey}/^\${reset}${darkBrown}=${blinkingFlameWhite}^${reset}${darkBrown}=${blinkingFlameWhite}^^${reset}${darkBrown}=${blinkingFlameWhite}^${reset}${darkBrown}=${darkGrey}/^\${brickRed}| _=-_-_\${reset}
  ${red}""""${darkGreen}|${red}'${white}.${red}'${white}.${red}'${white}.${darkGreen}|${darkGreen}~~${blue}|${lightBlue}.${golden}*${lightBlue}.${golden}*${lightBlue}.${golden}*${lightRed}|${blue}     ____${lightRed}|${blue}_   ${grey}=${reset}${white}(${lightGrey}'${fleshMorePink}.${white}${lightGrey}'${white})${reset}${grey}=${reset}     ${lightGrey},------------.${reset}      
      ${darkGreen}|${red}'${white}.${red}'${white}.${red}'${white}.${darkGreen}|   ${blue}^^^^^^${lightRed}|____${blue}|${white}>>>>>>${blue}|  ${white}( ~~~ )${reset}    ${lightGrey}(((((((())))))))${reset}   
      ${darkGreen}~~~~~~~~${reset}         ${lightRed}'""""${blue}``------'  ${white}``${fleshMorePink}w${white}---${fleshMorePink}w${white}``${reset}     ${lightGrey}``------------'${reset}
"@
    # Join the array elements into a single string
    $christmas = $christmas -join ''

    # Define an array of possible colors for the '+' characters
    $starColors = @($blinkingLightBlue, $blinkingIndigo, $blinkingRed, $blinkingGreen, $blinkingOrange, $blinkingWhite, $blinkingYellow)

    # Replace '*' characters with randomly selected colors
    $christmas = $christmas -replace "\+","${blinkingWhite}+${reset}${darkGreen}"
    
    # Join the array elements into a single string
    $christmas = $christmas -join ''
    
    # Define an array of possible colors for the '?' and '%' characters
    $ornamentColors = @($red, $darkRed, $green, $white, $golden)
    
    # Replace '%' characters with randomly selected colors
    $christmas = $christmas -replace '%',"${golden}%${darkGreen}"
    
    # Join the array elements into a single string
    $christmas = $christmas -join ''
    
    # Replace '?' characters with randomly selected colors
    $christmas = $christmas -replace "\?","${red}?${darkGreen}"
    
    # Join the array elements into a single string
    $christmas = $christmas -join ''
 
    # Display the colorized ASCII art
    Write-Host $christmas
}
christmas-colorized
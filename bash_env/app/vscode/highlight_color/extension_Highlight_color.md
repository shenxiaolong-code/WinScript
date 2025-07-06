

Highlight
code --force --install-extension  fabiospampinato.vscode-highlight
copy settings_highlight_color.json into : C:\Users\xiaolongs\AppData\Roaming\Code\User\settings.json

https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-highlight

{
  "highlight.decorations": {"rangeBehavior": 3},    // 所有其他装饰都继承自的默认装饰
  "highlight.regexFlags": "gi",                     // 构建正则表达式时使用的默认标志
  "highlight.regexes": {},                          // 将正则表达式对象映射到选项或装饰数组以应用于捕获组
  "highlight.minDelay": 50,                         // 更改后突出显示文档之前等待的最小毫秒数，用于限制
  "highlight.maxMatches": 250                       // 每个正则表达式装饰的最大匹配数，以免意外的灾难性正则表达式导致应用程序崩溃
}

"highlight.regexes": {
  "(//TODO)(:)": { // 将从该字符串创建一个正则表达式，不要忘记对其进行双重转义
     "regexFlags": "g",                     // 构建此正则表达式时使用的标志
     "filterLanguageRegex": "markdown",     // 仅当当前文件的语言与此正则表达式匹配时应用。 需要双重转义
     "filterFileRegex": ".*\\.ext",         // 仅当当前文件的路径与此正则表达式匹配时应用。 需要双重转义
     "decorations": [                       // 应用于捕获组的装饰选项
       {"color": "yellow"},                 // 应用于第一个捕获组的装饰选项，在本例中为 "//TODO"
       {"color": "red"}                     // 应用于第二个捕获组的装饰选项，在本例中为 ":"
     ]
   }
}

// https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-highlight
// https://github.com/fabiospampinato/vscode-highlight    

highlight.regexFlags 是一个配置项，用于设置正则表达式的标志，default value : "gm" , 这个值表示全局匹配（g）和多行匹配（m）
g ： 全局匹配。表示匹配尽可能多的符合模式的字符串，而不是在找到第一个就停止。
i ： 忽略大小写。表示在匹配时忽略大小写。
m ： 多行匹配。表示 ^ 和 $ 可以匹配每一行的开始和结束，而不仅仅是整个字符串的开始和结束。
     匹配行首： ^(.*)
     匹配行尾： (.*)$
s ： 单行模式。表示。可以匹配任何字符，包括换行符。
u ： Unicode 模式。表示正则表达式应该以全 Unicode 匹配。
y ： 粘性匹配。表示只匹配从目标字符串的当前位置开始的字符串。

你可以根据需要组合这些标志。例如，如果你想进行全局匹配并忽略大小写，你可以设置 highlight.regexFlags 为 "gi"

简单用法 ： 使用正则表达式，每个不同的颜色的字符串，用一个 () 来表达，然后 [] 下面的每个 {} 来指定其对应顺序的颜色 。
比如下面，//TODO 是第一个，fix me 是第二个
//TODO : fix me

    "highlight.regexes": {
        "(// *TODO:?)(.*)": {
            "decorations": [
                {
                    "backgroundColor": "#1e1e1e",
                    "color": "#d2c213",
                    "fontWeight": "bold",
                    "overviewRulerColor": "#bb45b7"
                },
                {
                    "backgroundColor": "#1e1e1e",
                    "color": "#e232eb"
                }
            ]
        },
        "(/home/[^ :]+)": {
            //"filterFileRegex": ".*.txt$",                   // only apply .txt file
            "filterFileRegex": ".*(.txt|.log)$",              // only apply .txt and .log file
            // "filterFileRegex": ".*(?<!.txt)$",             // all files only exclude .txt file
            "decorations": [
                {
                    "backgroundColor": "#1e1e1e",
                    "color": "#2f9288"
                },
            ],
        },
    },
    

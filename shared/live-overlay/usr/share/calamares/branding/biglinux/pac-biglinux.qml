import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Item {
    id: root
    width: 800
    height: 600
    focus: true

    property string gameVersion: "1.1.0"
    property string versionName: "Pac-BigLinux Beta"
    property int cellSize: Math.min(width / 28, height / 36)
    property int gameBoardWidth: 28 * cellSize
    property int gameBoardHeight: 31 * cellSize
    property int pacmanX: 14
    property int pacmanY: 23
    property int pacmanDirection: 0 // 0: right, 1: down, 2: left, 3: up
    property int nextDirection: -1
    property int score: 0
    property int lives: 5
    property bool gameRunning: false
    property bool powerMode: false
    property int powerModeTime: 0
    property bool gamePaused: false
    property int gameFrameCount: 0
    property int currentLevel: 1 // Controle de nível atual (1-5)
    
    // Coleção de labirintos para diferentes níveis
    property var mazesCollection: [
        // Nível 1 - Labirinto clássico
        [
            "############################",
            "#............##............#",
            "#.####.#####.##.#####.####.#",
            "#o####.#####.##.#####.####o#",
            "#.####.#####.##.#####.####.#",
            "#..........................#",
            "#.####.##.########.##.####.#",
            "#.####.##.########.##.####.#",
            "#......##....##....##......#",
            "######.##### ## #####.######",
            "######.##### ## #####.######",
            "######.##          ##.######",
            "######.## ######## ##.######",
            "######.## #      # ##.######",
            "      .   #      #   .      ",
            "######.## #      # ##.######",
            "######.## ######## ##.######",
            "######.##          ##.######",
            "######.## ######## ##.######",
            "######.## ######## ##.######",
            "#............##............#",
            "#.####.#####.##.#####.####.#",
            "#.####.#####.##.#####.####.#",
            "#o..##.......  .......##..o#",
            "###.##.##.########.##.##.###",
            "###.##.##.########.##.##.###",
            "#......##....##....##......#",
            "#.##########.##.##########.#",
            "#.##########.##.##########.#",
            "#..........................#",
            "############################"
        ],
        // Nível 2 - Redesenhado para melhor jogabilidade - INICIO
        [
            "############################",
            "#............##............#",
            "#.####.#####.##.#####.####.#",
            "#o####.#####.##.#####.####o#",
            "#.####.#####.##.#####.####.#",
            "#..........................#",
            "#.####.##.########.##.####.#",
            "#.####.##.########.##.####.#",
            "#......##....##....##......#",
            "#.##########.##.############",
            "#......#####.##.#####......#",
            "#.####.##          ##.####.#",
            "#.####.## ######## ##.####.#",
            "#.####.## #      # ##.####.#",
            "#......   #      #   ......#",
            "#.####.## #      # ##.####.#",
            "#.####.## ######## ##.####.#",
            "#.####.##          ##.####.#",
            "#......#####.##.#####......#",
            "#.##########.##.############",
            "#......##....##....##......#",
            "#.####.##.########.##.####.#",
            "#.####.##.########.##.####.#",
            "#o..##................##..o#",
            "###.##.##.########.##.##.###",
            "###.##.##.########.##.##.###",
            "#......##....##....##......#",
            "#.##########.##.##########.#",
            "#.##########.##.##########.#",
            "#..........................#",
            "############################"
        ],
        // Nível 3 - Labirinto com mais obstáculos
        [
            "############################",
            "#o...........##...........o#",
            "#.##########.##.##########.#",
            "#.#........#.##.#........#.#",
            "#.#.######.#.##.#.######.#.#",
            "#.#.#....#.#.##.#.#....#.#.#",
            "#.#.#.##.#.#.##.#.#.##.#.#.#",
            "#.#.#.##.#.#.##.#.#.##.#.#.#",
            "#...#....#......#....#.....#",
            "###.#.##.########.##.#.#####",
            "###.#.##.########.##.#.#####",
            "###.#.##          ##.#.#####",
            "###.#.## ######## ##.#.#####",
            "###...## #      # ##.......#",
            "      .  #      #    .      ",
            "###...## #      # ##.......#",
            "###.#.## ######## ##.#.###.#",
            "###.#.##          ##.#.###.#",
            "###.#.##.########.##.#.###.#",
            "###.#.##.########.##.#.###.#",
            "#...#..................#...#",
            "#.###.#######.##.#######.###",
            "#.###.#######.##.#######.###",
            "#o........................o#",
            "###.#############.########.#",
            "###.#############.########.#",
            "#..........................#",
            "#.##########.#####.#######.#",
            "#.##########.#####.#######.#",
            "#..........................#",
            "############################"
        ],
        // Nível 4 - Labirinto mais aberto mas com divisores
        [
            "############################",
            "#o........................o#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#..........................#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#..........................#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#..........................#",
            "#.####.#### ## ####.####.#.#",
            "#.####.#### ## ####.####.#.#",
            "#....... #      # .........#",
            "######## #      # ########## ",
            "#....... #      # .........#",
            "#.####.#### ## ####.####.#.#",
            "#.####.#### ## ####.####.#.#",
            "#..........................#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#..........................#",
            "#.####.####.#.##.####.####.#",
            "#o####.####......####.####o#",
            "#.####.####.#.##.####.####.#",
            "#..........................#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#.####.####.####.####.####.#",
            "#..........................#",
            "############################"
        ],
        // Nível 5 - Labirinto complexo final
        [
            "############################",
            "#o#........#....#........#o#",
            "#.#.######.#.##.#.######.#.#",
            "#.#.#....#.#.##.#.#....#.#.#",
            "#.#.#.##.#.#.##.#.#.##.#.#.#",
            "#...#.##.#......#.#.##.....#",
            "###.#.##.########.#.########",
            "#...#.##...................#",
            "#.###.##############.#####.#",
            "#.#...#...........##....##.#",
            "#.#.#.#.#########.#####.##.#",
            "#...#...#.......#.....#.##.#",
            "###.###.#.#####.#####.#.##.#",
            "#...#...#.#...#...#...#.##.#",
            "#.###.###.#.#.###.#.###.##.#",
            "#.#...#...#.#...#.#...#....#",
            "#.#.###.###.###.#.###.####.#",
            "#...#...#...#...#...#....#.#",
            "###.#.#####.#.#####.####.#.#",
            "#...#.....#.#.....#..#.....#",
            "#.#######.#.#####.##.#.###.#",
            "#...#.....#.....#....#.....#",
            "###.#.#########.##########.#",
            "#o..#.............#.......o#",
            "#.###############.#.######.#",
            "#.#...............#.#....#.#",
            "#.#.###############.#.##.#.#",
            "#.#.###############.#.##.#.#",
            "#.#.#################.##.#.#",
            "#..........................#",
            "############################"
        ]
    ]
    
    property var maze: []
    
    // Ampliado para 6 fantasmas, incluindo Manjaro e Pop!_OS
    property var ghosts: [
        {x: 12, y: 14, dir: 0, speed: 1, color: "red", targetX: 0, targetY: 0, mode: "chase", inCage: true, blinking: false},
        {x: 14, y: 14, dir: 0, speed: 0.95, color: "pink", targetX: 27, targetY: 0, mode: "scatter", inCage: true, blinking: false},
        {x: 16, y: 14, dir: 0, speed: 0.9, color: "cyan", targetX: 0, targetY: 30, mode: "scatter", inCage: true, blinking: false},
        {x: 12, y: 15, dir: 0, speed: 0.85, color: "orange", targetX: 27, targetY: 30, mode: "scatter", inCage: true, blinking: false},
        {x: 14, y: 15, dir: 0, speed: 0.92, color: "green", targetX: 14, targetY: 0, mode: "scatter", inCage: true, blinking: false}, // Manjaro
        {x: 16, y: 15, dir: 0, speed: 0.88, color: "purple", targetX: 14, targetY: 30, mode: "scatter", inCage: true, blinking: false} // Pop!_OS
    ]
    
    // Dot counter
    property int totalDots: 0
    property int ghostModeCounter: 0
    property int ghostBlinkCounter: 0
    property int ghostReleaseCounter: 0
    
    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
    }
    
    Item {
        id: gameBoard
        width: gameBoardWidth
        height: gameBoardHeight
        anchors.centerIn: parent
        
        // Draw maze walls
        Repeater {
            model: maze.length
            Item {
                property int y_index: index
                
                Repeater {
                    model: maze[y_index].length
                    Rectangle {
                        width: cellSize
                        height: cellSize
                        x: index * cellSize
                        y: y_index * cellSize
                        color: maze[y_index][index] === '#' ? "blue" : "transparent"
                        visible: maze[y_index][index] === '#'
                    }
                }
            }
        }
    }
    
    // Score
    Text {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Score: " + score
        color: "white"
        font.pixelSize: 20
        font.bold: true
    }
    
    // Lives
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 5
        
        Text {
            text: "Lives: "
            color: "white"
            font.pixelSize: 16
        }
        
        Repeater {
            model: lives
            Image {
                width: 18
                height: 18
                source: "bigcomecome.svg"
                sourceSize.width: width
                sourceSize.height: height
            }
        }
    }
    
    // Game Over message
    Rectangle {
        id: gameOverMessage
        anchors.centerIn: parent
        width: 300
        height: 150
        color: Qt.rgba(0, 0, 0, 0.8)
        visible: false
        radius: 10
        
        Text {
            anchors.centerIn: parent
            text: "Game Over\nPress Space to Restart"
            color: "red"
            font.pixelSize: 24
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Win message
    Rectangle {
        id: winMessage
        anchors.centerIn: parent
        width: 300
        height: 150
        color: Qt.rgba(0, 0, 0, 0.8)
        visible: false
        radius: 10
        
        Text {
            anchors.centerIn: parent
            text: "Congratulations!\nYou completed all 5 levels!\nPress Space to Restart"
            color: "green"
            font.pixelSize: 24
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Pause Game
    Rectangle {
        id: pauseIndicator
        anchors.centerIn: parent
        width: 200
        height: 100
        color: Qt.rgba(0, 0, 0, 0.8)
        visible: gamePaused
        radius: 10
        
        Text {
            anchors.centerIn: parent
            text: "PAUSA\nPressione P para continuar"
            color: "white"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Mensagem de nível
    Rectangle {
        id: levelMessage
        anchors.centerIn: parent
        width: 300
        height: 150
        color: Qt.rgba(0, 0, 0, 0.8)
        visible: false
        radius: 10
        
        Text {
            id: levelText
            anchors.centerIn: parent
            text: "Nível " + currentLevel
            color: "yellow"
            font.pixelSize: 32
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
        
        Timer {
            id: levelMessageTimer
            interval: 2000
            onTriggered: {
                levelMessage.visible = false;
                gameRunning = true;
            }
        }
    }
    
    // Componente de diálogo "Sobre"
    Rectangle {
        id: aboutDialog
        anchors.centerIn: parent
        width: 400
        height: 300
        color: Qt.rgba(0, 0, 0, 0.9)
        visible: false
        z: 1000
        radius: 10
        
        Text {
            anchors.centerIn: parent
            width: parent.width - 40
            text: "Pac-BigLinux " + gameVersion + "\n\n" +
                "A Pac-Man game themed around Linux distributions\n\n" +
                "Developed by: Tales A. Mendonça - @talesam\n" +
                "Date: " + Qt.formatDate(new Date(), "dd/MM/yyyy") + "\n\n" +
                "Press ESC to close"
            color: "white"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Tela inicial - adicionada para iniciar o jogo com espaço
    Rectangle {
        id: startScreen
        anchors.fill: parent
        color: "black"
        visible: true
        z: 100 // Fica acima de tudo
        
        Text {
            anchors.centerIn: parent
            text: "<font color='yellow'>PAC-BigLinux</font><br><br><font color='blue'>Press SPACE to start</font>"
            textFormat: Text.RichText
            font.pixelSize: 32
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
        
        Image {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 50
            source: "bigcomecome.svg"
            width: 64
            height: 64
        }
        // Texto de versão na parte inferior
        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10
            text: versionName + " v" + gameVersion
            color: "#888888"
            font.pixelSize: 14
        }
    }
    
    // Draw dots and power pills
    Repeater {
        id: dotsRepeater
        model: maze.length
        
        Item {
            property int y_index: index
            
            Repeater {
                id: rowRepeater
                model: maze[y_index].length
                
                Item {
                    x: index * cellSize + gameBoard.x
                    y: y_index * cellSize + gameBoard.y
                    width: cellSize
                    height: cellSize
                    visible: maze[y_index][index] === '.' || maze[y_index][index] === 'o'
                    
                    Rectangle {
                        // Para pontos normais
                        visible: maze[y_index][index] === '.'
                        width: cellSize * 0.1  // 10% do tamanho da célula
                        height: cellSize * 0.1 // 10% do tamanho da célula
                        radius: width / 2
                        color: "white"
                        anchors.centerIn: parent
                    }
                    
                    Rectangle {
                        // Para power pills - AUMENTADAS EM 20%
                        visible: maze[y_index][index] === 'o'
                        width: cellSize * 0.24  // 20% maior que antes (0.2 * 1.2 = 0.24)
                        height: cellSize * 0.24 // 20% maior que antes
                        radius: width / 2
                        color: "white"
                        anchors.centerIn: parent
                        
                        // Animação existente
                        SequentialAnimation {
                            running: parent.visible
                            loops: Animation.Infinite
                            
                            PropertyAnimation {
                                target: parent
                                properties: "opacity"
                                to: 0.3
                                duration: 500
                            }
                            
                            PropertyAnimation {
                                target: parent
                                properties: "opacity"
                                to: 1.0
                                duration: 500
                            }
                        }
                    }
                }
            }
        }
    }

    // BigComeCome
    Item {
        id: pacman
        width: cellSize * 0.9
        height: cellSize * 0.9
        x: gameBoard.x + pacmanX * cellSize + cellSize * 0.05
        y: gameBoard.y + pacmanY * cellSize + cellSize * 0.05
        
        // Animação com duração maior para movimentos lentos mas suaves
        Behavior on x {
            NumberAnimation { 
                duration: 180  // Duração mais longa para movimento lento mas suave
                easing.type: Easing.OutQuad
            }
        }
        
        Behavior on y {
            NumberAnimation { 
                duration: 180  // Duração mais longa para movimento lento mas suave
                easing.type: Easing.OutQuad
            }
        }
        
        Image {
            id: biglinuxLogo
            source: "bigcomecome.svg" 
            anchors.fill: parent
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            
            // Rotação baseada na direção
            rotation: {
                switch(pacmanDirection) {
                    case 0: return 0;   // direita
                    case 1: return 90;  // baixo
                    case 2: return 180; // esquerda
                    case 3: return 270; // cima
                    default: return 0;
                }
            }
            
            // Animação de rotação suave
            Behavior on rotation {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
    
    // DistroGhost
    Repeater {
        id: ghostRepeater
        model: ghosts.length
        
        Item {
            id: distroGhost
            width: cellSize * 0.9
            height: cellSize * 0.9
            x: gameBoard.x + ghosts[index].x * cellSize + cellSize * 0.05
            y: gameBoard.y + ghosts[index].y * cellSize + cellSize * 0.05
            
            // Smooth movement behavior com duração maior para movimento lento
            Behavior on x {
                enabled: !powerMode // Desative durante o modo de poder para movimento imediato
                NumberAnimation { 
                    duration: 180
                    easing.type: Easing.OutQuad
                }
            }
            
            Behavior on y {
                enabled: !powerMode
                NumberAnimation { 
                    duration: 180
                    easing.type: Easing.OutQuad
                }
            }
            
            // Canvas para o fantasma no modo assustado (power mode)
            Canvas {
                id: scaredGhostCanvas
                anchors.fill: parent
                visible: powerMode && !ghosts[index].inCage
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    
                    // Corpo principal do fantasma
                    ctx.fillStyle = ghosts[index].blinking ? "white" : "blue";
                    ctx.beginPath();
                    ctx.arc(width / 2, height / 2, width / 2, Math.PI, 0, false);
                    ctx.lineTo(width, height);
                    
                    // Ondulações na base
                    var waveCount = 4;
                    var waveWidth = width / waveCount;
                    for (var i = waveCount; i >= 0; i--) {
                        var x = i * waveWidth;
                        var y = height - ((i % 2) ? height * 0.1 : 0);
                        ctx.lineTo(x, y);
                    }
                    
                    ctx.lineTo(0, height);
                    ctx.lineTo(0, height / 2);
                    ctx.fill();
                    
                    // Olhos
                    ctx.fillStyle = "white";
                    ctx.beginPath();
                    ctx.arc(width * 0.3, height * 0.4, width * 0.12, 0, 2 * Math.PI);
                    ctx.arc(width * 0.7, height * 0.4, width * 0.12, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Pupilas
                    ctx.fillStyle = "black";
                    ctx.beginPath();
                    ctx.arc(width * 0.3, height * 0.4, width * 0.06, 0, 2 * Math.PI);
                    ctx.arc(width * 0.7, height * 0.4, width * 0.06, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Boca assustada
                    ctx.lineWidth = width * 0.05;
                    ctx.strokeStyle = "white";
                    ctx.beginPath();
                    ctx.moveTo(width * 0.3, height * 0.65);
                    ctx.lineTo(width * 0.5, height * 0.7);
                    ctx.lineTo(width * 0.7, height * 0.65);
                    ctx.stroke();
                }
            }
            
            // Canvas para os logos de distribuições
            Canvas {
                id: distroCanvas
                anchors.fill: parent
                visible: !powerMode || ghosts[index].inCage
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    
                    // Formas básicas dos fantasmas (corpo semi-transparente)
                    ctx.fillStyle = Qt.rgba(0.9, 0.9, 0.9, 0.1);
                    ctx.beginPath();
                    ctx.arc(width / 2, height / 2, width / 2, Math.PI, 0, false);
                    ctx.lineTo(width, height);
                    
                    // Ondulações na base
                    var waveCount = 4;
                    var waveWidth = width / waveCount;
                    for (var i = waveCount; i >= 0; i--) {
                        var x = i * waveWidth;
                        var y = height - ((i % 2) ? height * 0.1 : 0);
                        ctx.lineTo(x, y);
                    }
                    
                    ctx.lineTo(0, height);
                    ctx.lineTo(0, height / 2);
                    ctx.fill();
                    
                    // Desenha o logo específico com base no índice
                    switch(index) {
                        case 0: // Debian (vermelho)
                            drawDebianLogo(ctx, width, height);
                            break;
                        case 1: // Ubuntu (laranja)
                            drawUbuntuLogo(ctx, width, height);
                            break;
                        case 2: // Fedora (azul)
                            drawFedoraLogo(ctx, width, height);
                            break;
                        case 3: // Arch (azul claro)
                            drawArchLogo(ctx, width, height);
                            break;
                        case 4: // Manjaro (verde)
                            drawManjaroLogo(ctx, width, height);
                            break;
                        case 5: // Pop!_OS (roxo)
                            drawPopOSLogo(ctx, width, height);
                            break;
                    }
                }
                
                // Funções para desenhar os logos
                function drawDebianLogo(ctx, width, height) {
                    ctx.fillStyle = "#D70A53"; // Vermelho Debian
                    
                    // Espiral Debian simplificada
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.4, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Espiral interna (branca)
                    ctx.fillStyle = "white";
                    ctx.beginPath();
                    
                    var centerX = width * 0.5;
                    var centerY = height * 0.5;
                    var maxRadius = width * 0.35;
                    var startRadius = maxRadius * 0.2;
                    
                    // Desenha a espiral
                    ctx.moveTo(centerX, centerY);
                    for (var angle = 0; angle < 6 * Math.PI; angle += 0.1) {
                        var radius = startRadius + (angle / 20) * maxRadius;
                        var x = centerX + radius * Math.cos(angle);
                        var y = centerY + radius * Math.sin(angle);
                        
                        if (radius > maxRadius) break;
                        
                        ctx.lineTo(x, y);
                    }
                    ctx.fill();
                }
                
                function drawUbuntuLogo(ctx, width, height) {
                    ctx.fillStyle = "#E95420"; // Laranja Ubuntu
                    
                    // Círculo principal
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.4, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Círculos brancos representando pessoas
                    ctx.fillStyle = "white";
                    
                    // Círculo superior
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.3, width * 0.1, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Círculo inferior esquerdo
                    ctx.beginPath();
                    ctx.arc(width * 0.35, height * 0.65, width * 0.1, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Círculo inferior direito
                    ctx.beginPath();
                    ctx.arc(width * 0.65, height * 0.65, width * 0.1, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Linhas conectando os círculos
                    ctx.strokeStyle = "white";
                    ctx.lineWidth = width * 0.04;
                    ctx.beginPath();
                    ctx.moveTo(width * 0.5, height * 0.3);
                    ctx.lineTo(width * 0.35, height * 0.65);
                    ctx.lineTo(width * 0.65, height * 0.65);
                    ctx.closePath();
                    ctx.stroke();
                }
                
                function drawFedoraLogo(ctx, width, height) {
                    ctx.fillStyle = "#294172"; // Azul Fedora
                    
                    // Círculo principal
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.4, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // "f" estilizado
                    ctx.fillStyle = "white";
                    ctx.beginPath();
                    
                    // Haste vertical
                    ctx.rect(width * 0.4, height * 0.3, width * 0.1, height * 0.4);
                    
                    // Haste horizontal superior
                    ctx.rect(width * 0.4, height * 0.3, width * 0.25, height * 0.1);
                    
                    // Haste horizontal do meio
                    ctx.rect(width * 0.4, height * 0.45, width * 0.2, height * 0.1);
                    
                    ctx.fill();
                }
                
                function drawArchLogo(ctx, width, height) {
                    ctx.fillStyle = "#1793D1"; // Azul Arch
                    
                    // Círculo principal
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.4, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Triângulo Arch simplificado
                    ctx.fillStyle = "white";
                    ctx.beginPath();
                    ctx.moveTo(width * 0.5, height * 0.25);
                    ctx.lineTo(width * 0.3, height * 0.7);
                    ctx.lineTo(width * 0.7, height * 0.7);
                    ctx.closePath();
                    ctx.fill();
                    
                    // Círculo no topo
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.35, width * 0.06, 0, 2 * Math.PI);
                    ctx.fill();
                }
                
                function drawManjaroLogo(ctx, width, height) {
                    // Limpar a área
                    ctx.fillStyle = "#35BF5C"; // Verde Manjaro correto
                    
                    // Desenhar fundo
                    ctx.beginPath();
                    ctx.rect(0, 0, width, height);
                    ctx.fill();
                    
                    // Desenhar as barras brancas - mais precisas
                    ctx.fillStyle = "white";
                    
                    // Barra esquerda - altura completa
                    var barWidth = width * 0.18;
                    var gap = width * 0.07;
                    
                    // Primeira barra (esquerda) - altura completa
                    ctx.fillRect(width * 0.15, height * 0.15, barWidth, height * 0.7);
                    
                    // Segunda barra (meio) - começa mais abaixo
                    ctx.fillRect(width * 0.15 + barWidth + gap, height * 0.15 + height * 0.25, barWidth, height * 0.45);
                    
                    // Terceira barra (direita) - altura completa
                    ctx.fillRect(width * 0.15 + 2 * (barWidth + gap), height * 0.15, barWidth, height * 0.7);
                }
                
                function drawPopOSLogo(ctx, width, height) {
                    ctx.fillStyle = "#48B9C7"; // Azul-verde Pop!_OS
                    
                    // Círculo principal
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.4, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Círculo interno (branco)
                    ctx.fillStyle = "white";
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.5, width * 0.25, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Desenhar símbolo "!" estilizado
                    ctx.fillStyle = "#48B9C7";
                    
                    // Ponto superior
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.4, width * 0.05, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    // Linha vertical
                    ctx.fillRect(width * 0.475, height * 0.5, width * 0.05, height * 0.15);
                }
            }
        }
    }
    
    // Pontuação flutuante
    Text {
        id: pointsText
        color: "white"
        font.pixelSize: 16
        font.bold: true
        visible: false
    }

    Timer {
        id: pointsTextTimer
        interval: 1000
        onTriggered: pointsText.visible = false
    }

    // Initialization and dot counting
    Component.onCompleted: {
        countDots();
        
        // Apenas prepara o jogo, não inicia até pressionar espaço
        prepareGame();
        
        // Mostra a tela inicial
        startScreen.visible = true;
        gameRunning = false;
    }
    
    // Função para preparar o jogo sem iniciá-lo
    function prepareGame() {
        // Reset positions
        pacmanX = 14;
        pacmanY = 23;
        pacmanDirection = 0;
        nextDirection = -1;
        
        score = 0;
        lives = 5;
        currentLevel = 1;
        
        powerMode = false;
        powerModeTime = 0;
        ghostModeCounter = 0;
        gameFrameCount = 0;
        
        // Inicializa os fantasmas em 3 colunas x 2 linhas
        ghosts = [
            {x: 12, y: 14, dir: 0, speed: 1, color: "red", targetX: 0, targetY: 0, mode: "chase", inCage: true, blinking: false},
            {x: 14, y: 14, dir: 0, speed: 0.95, color: "pink", targetX: 27, targetY: 0, mode: "scatter", inCage: true, blinking: false},
            {x: 16, y: 14, dir: 0, speed: 0.9, color: "cyan", targetX: 0, targetY: 30, mode: "scatter", inCage: true, blinking: false},
            {x: 12, y: 15, dir: 0, speed: 0.85, color: "orange", targetX: 27, targetY: 30, mode: "scatter", inCage: true, blinking: false},
            {x: 14, y: 15, dir: 0, speed: 0.92, color: "green", targetX: 14, targetY: 0, mode: "scatter", inCage: true, blinking: false}, // Manjaro
            {x: 16, y: 15, dir: 0, speed: 0.88, color: "purple", targetX: 14, targetY: 30, mode: "scatter", inCage: true, blinking: false} // Pop!_OS
        ];
        
        // Seleciona o labirinto inicial
        maze = mazesCollection[0].slice();
        
        countDots();
        
        // Atualize visualmente os pontos
        dotsRepeater.model = 0;
        dotsRepeater.model = maze.length;
        
        // NÃO inicia o jogo ainda
        gameRunning = false;
    }
    
    function countDots() {
        totalDots = 0;
        for (var y = 0; y < maze.length; y++) {
            for (var x = 0; x < maze[y].length; x++) {
                if (maze[y][x] === '.' || maze[y][x] === 'o') {
                    totalDots++;
                }
            }
        }
    }
    
    function advanceToNextLevel() {
        // Incrementa o nível
        currentLevel++;
        
        // Mantém os pontos e vidas
        var currentScore = score;
        var currentLives = lives;
        
        // Reinicia o jogo com o novo nível
        initGame(false);
        
        // Restaura pontos e vidas
        score = currentScore;
        lives = currentLives;
        
        // Mostra mensagem de próximo nível
        showLevelMessage();
    }
    
    function showLevelMessage() {
        levelText.text = "Nível " + currentLevel;
        levelMessage.visible = true;
        gameRunning = false;
        levelMessageTimer.restart();
    }
    
    function initGame(resetScore = true) {
        // Reset positions
        pacmanX = 14;
        pacmanY = 23;
        pacmanDirection = 0;
        nextDirection = -1;
        
        if (resetScore) {
            score = 0;
            currentLevel = 1;
            lives = 5; // Reinicia as vidas quando reinicia o jogo
        }
        
        powerMode = false;
        powerModeTime = 0;
        ghostModeCounter = 0;
        gameFrameCount = 0;
        
        // Reset ghosts - reorganizados em 3 colunas x 2 linhas
        ghosts = [
            {x: 12, y: 14, dir: 0, speed: 1, color: "red", targetX: 0, targetY: 0, mode: "chase", inCage: true, blinking: false},
            {x: 14, y: 14, dir: 0, speed: 0.95, color: "pink", targetX: 27, targetY: 0, mode: "scatter", inCage: true, blinking: false},
            {x: 16, y: 14, dir: 0, speed: 0.9, color: "cyan", targetX: 0, targetY: 30, mode: "scatter", inCage: true, blinking: false},
            {x: 12, y: 15, dir: 0, speed: 0.85, color: "orange", targetX: 27, targetY: 30, mode: "scatter", inCage: true, blinking: false},
            {x: 14, y: 15, dir: 0, speed: 0.92, color: "green", targetX: 14, targetY: 0, mode: "scatter", inCage: true, blinking: false}, // Manjaro
            {x: 16, y: 15, dir: 0, speed: 0.88, color: "purple", targetX: 14, targetY: 30, mode: "scatter", inCage: true, blinking: false} // Pop!_OS
        ];
        
        // Use o labirinto do nível atual (use um valor padrão se estiver fora do intervalo)
        var levelIndex = currentLevel - 1;
        if (levelIndex < 0 || levelIndex >= mazesCollection.length) {
            levelIndex = 0;
        }
        
        // Copia o labirinto do nível atual
        maze = mazesCollection[levelIndex].slice();
        
        countDots();
        gameRunning = true;
        gameOverMessage.visible = false;
        winMessage.visible = false;
        
        // Force visual update of dots
        dotsRepeater.model = 0;
        dotsRepeater.model = maze.length;
        
        // Start ghost release timer
        ghostReleaseTimer.restart();
        
        // Se não for o início do jogo, mostra mensagem de nível
        if (!resetScore && currentLevel > 1) {
            showLevelMessage();
        }
    }
    
    // Função para pular diretamente para um nível específico
    function jumpToLevel(level) {
        if (level >= 1 && level <= 5) {
            currentLevel = level;
            var currentLives = lives; // Preserva as vidas atuais
            initGame(false);
            lives = currentLives; // Restaura as vidas
            
            // Mostra mensagem do nível
            showLevelMessage();
        }
    }

    // Ghost release timer - liberar apenas o primeiro fantasma ao iniciar
    Timer {
        id: ghostReleaseTimer
        interval: 1500  // 1.5 segundos
        running: gameRunning
        repeat: true
        onTriggered: {
            // Se for a primeira vez, libera o primeiro fantasma
            if (gameFrameCount < 50) { // Verificar se ainda está no início do jogo
                var allInCage = true;
                for (var j = 0; j < ghosts.length; j++) {
                    if (!ghosts[j].inCage) {
                        allInCage = false;
                        break;
                    }
                }
                
                // Se todos estiverem na jaula, libera o primeiro
                if (allInCage) {
                    var ghostsCopy = ghosts.slice();
                    ghostsCopy[0].inCage = false;
                    ghostsCopy[0].x = 14;
                    ghostsCopy[0].y = 11;
                    ghosts = ghostsCopy;
                    return;
                }
            }
            
            // Libera fantasmas adicionais gradualmente
            for (var i = 0; i < ghosts.length; i++) {
                if (ghosts[i].inCage) {
                    console.log("Releasing ghost " + i);
                    var ghostsCopy = ghosts.slice();
                    ghostsCopy[i].inCage = false;
                    ghostsCopy[i].x = 14;
                    ghostsCopy[i].y = 11;
                    ghostsCopy[i].mode = "scatter"; // Reset mode when leaving cage
                    ghosts = ghostsCopy;
                    break;
                }
            }
        }
    }
    
    // Main game timer - debug para verificar se está funcionando
    Timer {
        id: gameTimer
        interval: 33  // ~30fps para movimento mais fluido
        running: gameRunning && !gamePaused
        repeat: true
        onTriggered: {
            // Incrementar contador de frames
            gameFrameCount++;
            
            // Debug para verificar o funcionamento (remover após teste)
            if (gameFrameCount % 30 === 0) {
                console.log("Game running: frame " + gameFrameCount + ", level " + currentLevel);
            }
            
            // Movimento baseado no nível atual (5, 4, 3, 2, 1)
            var frameStep = 6 - currentLevel; // Começa em 5 na fase 1, termina em 1 na fase 5
            if (frameStep < 1) frameStep = 1; // Garantir que não seja menor que 1
            
            // Mover Pac-Man com base no nível
            if (gameFrameCount % frameStep === 0) {
                movePacman();
                eatDot();
            }
            
            // Verificar colisão a cada frame para maior precisão
            checkGhostCollision();
            
            // Mover fantasmas com base no nível
            if (gameFrameCount % frameStep === 0) {
                for (var i = 0; i < ghosts.length; i++) {
                    if (!ghosts[i].inCage) {
                        moveGhost(i);
                    }
                }
            }
            
            // Atualizar o modo de poder - CONFIGURADO PARA 5 SEGUNDOS COMPLETOS
            if (powerMode) {
                if (gameFrameCount % 3 === 0) {  // Atualize mais frequentemente
                    powerModeTime--;
                    
                    // Faça os fantasmas piscarem nos últimos segundos
                    if (powerModeTime <= 30) { // Últimos 30 frames / ~1 segundo
                        ghostBlinkCounter++;
                        if (ghostBlinkCounter % 2 === 0) {
                            var ghostsCopy = ghosts.slice();
                            for (var j = 0; j < ghostsCopy.length; j++) {
                                if (ghostsCopy[j].mode === "frightened") {
                                    ghostsCopy[j].blinking = !ghostsCopy[j].blinking;
                                }
                            }
                            ghosts = ghostsCopy;
                        }
                    }
                    
                    if (powerModeTime <= 0) {
                        powerMode = false;
                        // Restaurar modos dos fantasmas
                        var ghostsCopy = ghosts.slice();
                        for (var k = 0; k < ghostsCopy.length; k++) {
                            if (ghostsCopy[k].mode === "frightened") {
                                ghostsCopy[k].mode = "chase";
                                ghostsCopy[k].blinking = false;
                            }
                        }
                        ghosts = ghostsCopy;
                    }
                }
            }
            
            // Alternar modos de fantasma com menos frequência
            if (gameFrameCount % 10 === 0) {  // A cada 10 frames
                ghostModeCounter++;
                if (ghostModeCounter % 60 === 0) { // Menos frequente
                    switchGhostMode();
                }
            }
            
            // Verificar vitória apenas quando necessário
            if (totalDots === 0 && gameRunning) {
                if (currentLevel < 5) {
                    // Avança para o próximo nível
                    advanceToNextLevel();
                } else {
                    // Jogador completou todos os 5 níveis
                    gameRunning = false;
                    winMessage.visible = true;
                }
            }
        }
    }
    
    function switchGhostMode() {
        var ghostsCopy = ghosts.slice();
        for (var i = 0; i < ghostsCopy.length; i++) {
            // Só alterna o modo se o fantasma não estiver em modo assustado
            if (ghostsCopy[i].mode === "scatter" && !powerMode) {
                ghostsCopy[i].mode = "chase";
            } else if (ghostsCopy[i].mode === "chase" && !powerMode) {
                ghostsCopy[i].mode = "scatter";
            }
            // Se estiver em modo assustado, deixa como está até o powerMode acabar
        }
        ghosts = ghostsCopy;
    }
    
    function movePacman() {
        // Check if desired direction is valid
        if (nextDirection !== -1) {
            var nx = pacmanX;
            var ny = pacmanY;
            
            switch (nextDirection) {
                case 0: nx++; break; // right
                case 1: ny++; break; // down
                case 2: nx--; break; // left
                case 3: ny--; break; // up
            }
            
            // Check board limits (tunnel)
            if (nx < 0) nx = maze[0].length - 1;
            if (nx >= maze[0].length) nx = 0;
            
            // If movement is valid, change direction
            if (ny >= 0 && ny < maze.length && maze[ny][nx] !== '#') {
                pacmanDirection = nextDirection;
                nextDirection = -1;
            }
        }
        
        // Move in current direction
        var x = pacmanX;
        var y = pacmanY;
        
        switch (pacmanDirection) {
            case 0: x++; break; // right
            case 1: y++; break; // down
            case 2: x--; break; // left
            case 3: y--; break; // up
        }
        
        // Check board limits (tunnel)
        if (x < 0) x = maze[0].length - 1;
        if (x >= maze[0].length) x = 0;
        
        // If movement is valid, update position
        if (y >= 0 && y < maze.length && maze[y][x] !== '#') {
            pacmanX = x;
            pacmanY = y;
        }
    }
    
    function eatDot() {
        // Check if there's a dot or power pill at Pacman's position
        if (pacmanY >= 0 && pacmanY < maze.length && pacmanX >= 0 && pacmanX < maze[pacmanY].length) {
            if (maze[pacmanY][pacmanX] === '.') {
                // Replace dot with empty space
                var newRow = maze[pacmanY].substr(0, pacmanX) + ' ' + maze[pacmanY].substr(pacmanX + 1);
                maze[pacmanY] = newRow;
                
                score += 10;
                totalDots--;
                
                // Force visual update
                dotsRepeater.model = 0;
                dotsRepeater.model = maze.length;
            } else if (maze[pacmanY][pacmanX] === 'o') {
                // Replace power pill with empty space
                var newRow = maze[pacmanY].substr(0, pacmanX) + ' ' + maze[pacmanY].substr(pacmanX + 1);
                maze[pacmanY] = newRow;
                
                score += 50;
                totalDots--;
                
                // Force visual update
                dotsRepeater.model = 0;
                dotsRepeater.model = maze.length;
                
                // Activate power mode - CONFIGURADO PARA 5 SEGUNDOS COMPLETOS
                powerMode = true;
                powerModeTime = 70; // Com atualização a cada 33ms e decremento a cada 3 frames, 50 = ~7 segundos
                ghostBlinkCounter = 0;
                
                // Put ghosts in frightened mode
                var ghostsCopy = ghosts.slice();
                for (var i = 0; i < ghostsCopy.length; i++) {
                    if (!ghostsCopy[i].inCage) {
                        ghostsCopy[i].mode = "frightened";
                        ghostsCopy[i].blinking = false;
                        // Reverse ghost direction
                        ghostsCopy[i].dir = (ghostsCopy[i].dir + 2) % 4;
                    }
                }
                ghosts = ghostsCopy;
            }
        }
    }
    
    function moveGhost(index) {
        // Evitar criar cópias desnecessárias
        if (index < 0 || index >= ghosts.length) return;
        
        var ghost = Object.assign({}, ghosts[index]);
        var originalX = ghost.x;
        var originalY = ghost.y;
        var originalDir = ghost.dir;
        var originalMode = ghost.mode;
        
        // Se o fantasma estiver dentro da gaiola, não aplica lógica de perseguição
        if (ghost.inCage) {
            return;
        }
        
        // Define ghost target based on mode
        if (ghost.mode === "chase") {
            // In chase mode, each ghost has different behavior
            switch (index) {
                case 0: // Red - directly chases Pacman
                    ghost.targetX = pacmanX;
                    ghost.targetY = pacmanY;
                    break;
                case 1: // Pink - aims 4 cells ahead of Pacman
                    ghost.targetX = pacmanX;
                    ghost.targetY = pacmanY;
                    // Aponta para 4 casas à frente do pacman na direção que ele está olhando
                    switch(pacmanDirection) {
                        case 0: ghost.targetX += 4; break;
                        case 1: ghost.targetY += 4; break;
                        case 2: ghost.targetX -= 4; break;
                        case 3: ghost.targetY -= 4; break;
                    }
                    break;
                case 2: // Cyan - position relative to Pacman and red ghost
                    var redGhost = ghosts[0];
                    var vectorX = 2 * (pacmanX - redGhost.x);
                    var vectorY = 2 * (pacmanY - redGhost.y);
                    ghost.targetX = pacmanX + vectorX;
                    ghost.targetY = pacmanY + vectorY;
                    break;
                case 3: // Orange - chases when far, scatters when close
                    var distSq = Math.pow(ghost.x - pacmanX, 2) + Math.pow(ghost.y - pacmanY, 2);
                    if (distSq > 64) { // If far from Pacman (8 cells away)
                        ghost.targetX = pacmanX;
                        ghost.targetY = pacmanY;
                    } else { // If close, goes to corner
                        ghost.targetX = 0;
                        ghost.targetY = 30;
                    }
                    break;
                case 4: // Manjaro - patrulha entre cantos superiores
                    var distSq = Math.pow(ghost.x - pacmanX, 2) + Math.pow(ghost.y - pacmanY, 2);
                    if (distSq > 36) { // If not too close
                        ghost.targetX = pacmanX;
                        ghost.targetY = pacmanY;
                    } else { // Alterna entre cantos
                        if (gameFrameCount % 100 < 50) {
                            ghost.targetX = 0;
                            ghost.targetY = 0;
                        } else {
                            ghost.targetX = 27;
                            ghost.targetY = 0;
                        }
                    }
                    break;
                case 5: // Pop!_OS - tenta emboscar antecipando a posição
                    var targetX = pacmanX;
                    var targetY = pacmanY;
                    
                    // Tenta prever para onde o Pac-Man vai
                    for (var i = 0; i < 6; i++) {
                        switch(pacmanDirection) {
                            case 0: targetX++; break;
                            case 1: targetY++; break;
                            case 2: targetX--; break;
                            case 3: targetY--; break;
                        }
                    }
                    
                    // Limites
                    if (targetX < 0) targetX = 0;
                    if (targetX >= maze[0].length) targetX = maze[0].length - 1;
                    if (targetY < 0) targetY = 0;
                    if (targetY >= maze.length) targetY = maze.length - 1;
                    
                    ghost.targetX = targetX;
                    ghost.targetY = targetY;
                    break;
            }
        } else if (ghost.mode === "scatter") {
            // Cada fantasma tem seu canto específico para ir
            switch (index) {
                case 0: // Red - top right
                    ghost.targetX = 27;
                    ghost.targetY = 0;
                    break;
                case 1: // Pink - top left
                    ghost.targetX = 0;
                    ghost.targetY = 0;
                    break;
                case 2: // Cyan - bottom left
                    ghost.targetX = 0;
                    ghost.targetY = 30;
                    break;
                case 3: // Orange - bottom right
                    ghost.targetX = 27;
                    ghost.targetY = 30;
                    break;
                case 4: // Manjaro - centro superior
                    ghost.targetX = 14;
                    ghost.targetY = 0;
                    break;
                case 5: // Pop!_OS - centro inferior
                    ghost.targetX = 14;
                    ghost.targetY = 30;
                    break;
            }
        } else if (ghost.mode === "frightened") {
            // In frightened mode, moves randomly
            ghost.targetX = Math.floor(Math.random() * maze[0].length);
            ghost.targetY = Math.floor(Math.random() * maze.length);
        }

        // Determine best direction to move toward target
        var bestDir = ghost.dir;
        var minDist = Number.MAX_VALUE;
        
        // Possible directions: 0: right, 1: down, 2: left, 3: up
        for (var dir = 0; dir < 4; dir++) {
            // Avoid direction reversal (except in frightened mode)
            if (dir === (ghost.dir + 2) % 4 && ghost.mode !== "frightened") {
                continue;
            }
            
            var nx = ghost.x;
            var ny = ghost.y;
            
            switch (dir) {
                case 0: nx++; break; // right
                case 1: ny++; break; // down
                case 2: nx--; break; // left
                case 3: ny--; break; // up
            }
            
            // Check board limits (tunnel)
            if (nx < 0) nx = maze[0].length - 1;
            if (nx >= maze[0].length) nx = 0;
            
            // If not a wall
            if (ny >= 0 && ny < maze.length && maze[ny][nx] !== '#') {
                var dist = Math.pow(nx - ghost.targetX, 2) + Math.pow(ny - ghost.targetY, 2);
                
                // In frightened mode, do the opposite
                if (ghost.mode === "frightened") {
                    dist = -dist;
                }
                
                if (dist < minDist) {
                    minDist = dist;
                    bestDir = dir;
                }
            }
        }
        
        // Update ghost direction
        ghost.dir = bestDir;
        
        // Move ghost in chosen direction
        var nx = ghost.x;
        var ny = ghost.y;
        
        switch (ghost.dir) {
            case 0: nx++; break; // right
            case 1: ny++; break; // down
            case 2: nx--; break; // left
            case 3: ny--; break; // up
        }
        
        // Check board limits (tunnel)
        if (nx < 0) nx = maze[0].length - 1;
        if (nx >= maze[0].length) nx = 0;
        
        // Move ghost if not a wall
        if (ny >= 0 && ny < maze.length && maze[ny][nx] !== '#') {
            ghost.x = nx;
            ghost.y = ny;
        } else {
            // If hits a wall, redefine direction randomly
            ghost.dir = Math.floor(Math.random() * 4);
        }
        
        // Só atualiza o array se algo realmente mudou (economiza processamento)
        if (ghost.x !== originalX || ghost.y !== originalY || 
            ghost.dir !== originalDir || ghost.mode !== originalMode) {
            var ghostsCopy = ghosts.slice();
            ghostsCopy[index] = ghost;
            ghosts = ghostsCopy;
        }
    }
    
    function checkGhostCollision() {
        var ghostsCopy = null;
    
        for (var i = 0; i < ghosts.length; i++) {
            var ghost = ghosts[i];
            
            // Detecção de colisão muito mais tolerante para garantir que funcione
            if (!ghost.inCage && 
                Math.abs(ghost.x - pacmanX) < 0.9 && 
                Math.abs(ghost.y - pacmanY) < 0.9) {
                
                if (powerMode) {
                    // Pacman eats ghost - pontuação crescente para cada fantasma comido
                    var points = 200 * Math.pow(2, i % 4); // 200, 400, 800, 1600
                    score += points;
                    
                    // Mostra a pontuação temporariamente
                    showPointsText(points);
                    
                    // Crie uma cópia do array apenas se necessário
                    if (!ghostsCopy) ghostsCopy = ghosts.slice();
                    
                    ghostsCopy[i].inCage = true;
                    ghostsCopy[i].x = 12 + (i % 3) * 2;
                    ghostsCopy[i].y = 14 + Math.floor(i / 3); // Distribui corretamente em 3x2
                    ghostsCopy[i].mode = "scatter";
                } else {
                    // Ghost catches Pacman
                    lives--;
                    if (lives <= 0) {
                        gameOver();
                    } else {
                        resetPositions();
                    }
                    break; // Não processa mais colisões depois de perder uma vida
                }
            }
        }
        
        // Atualiza o array de fantasmas apenas uma vez, se necessário
        if (ghostsCopy) {
            ghosts = ghostsCopy;
        }
    }
    
    function showPointsText(points) {
        pointsText.text = "+" + points;
        pointsText.x = gameBoard.x + pacmanX * cellSize;
        pointsText.y = gameBoard.y + pacmanY * cellSize - 20;
        pointsText.visible = true;
        pointsTextTimer.restart();
    }

    function resetPositions() {
        pacmanX = 14;
        pacmanY = 23;
        pacmanDirection = 0;
        nextDirection = -1;
        
        // Reposition ghosts em 3 colunas x 2 linhas
        var ghostsCopy = ghosts.slice();
        for (var i = 0; i < ghostsCopy.length; i++) {
            // Posições em 3 colunas x 2 linhas
            var col = i % 3;  // 0, 1, 2, 0, 1, 2
            var row = Math.floor(i / 3);  // 0, 0, 0, 1, 1, 1
            
            ghostsCopy[i].x = 12 + (col * 2); // 12, 14, 16, 12, 14, 16
            ghostsCopy[i].y = 14 + row;      // 14, 14, 14, 15, 15, 15
            ghostsCopy[i].dir = 0;
            ghostsCopy[i].inCage = true;
        }
        ghosts = ghostsCopy;
        
        // Restart ghost release timer
        ghostReleaseTimer.restart();
    }
    
    function gameOver() {
        gameRunning = false;
        gameOverMessage.visible = true;
    }
    
    // Função para mostrar a tela "Sobre"
    function showAbout() {
        aboutDialog.visible = true;
    }

    // Keyboard handlers - modificado para iniciar o jogo com espaço
    Keys.onPressed: {
        // Primeiro, verificar se o diálogo "Sobre" está visível
        if (aboutDialog.visible) {
            if (event.key === Qt.Key_Escape) {
                aboutDialog.visible = false;
            }
            return; // Ignorar outras teclas quando a tela "Sobre" estiver visível
        }
        
        // Se a tela inicial estiver visível, inicia o jogo com espaço
        if (event.key === Qt.Key_Space && startScreen.visible) {
            startScreen.visible = false;
            initGame(true); // Reinicia completamente o jogo
            return;
        }
        
        // Pula para a fase especificada (como um bloco independente)
        if (event.key >= Qt.Key_1 && event.key <= Qt.Key_5) {
            // Teclas 1-5 para pular para os níveis correspondentes
            jumpToLevel(event.key - Qt.Key_0); // Converte Qt.Key_1 para 1, Qt.Key_2 para 2, etc.
            return;
        }

        if (event.key === Qt.Key_F1) {
            showAbout();
        } else if (event.key === Qt.Key_P) {
            gamePaused = !gamePaused;
            gameTimer.running = gameRunning && !gamePaused;
        } else if (gameRunning && !gamePaused) {
            switch (event.key) {
                case Qt.Key_Right:
                case Qt.Key_D:
                    nextDirection = 0;
                    break;
                case Qt.Key_Down:
                case Qt.Key_S:
                    nextDirection = 1;
                    break;
                case Qt.Key_Left:
                case Qt.Key_A:
                    nextDirection = 2;
                    break;
                case Qt.Key_Up:
                case Qt.Key_W:
                    nextDirection = 3;
                    break;
            }
        } else if (!gameRunning && !startScreen.visible) {
            // Reiniciar após game over ou vitória
            if (event.key === Qt.Key_Space) {
                initGame();
            }
        }
    }
}
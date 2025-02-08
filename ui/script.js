document.addEventListener('DOMContentLoaded', () => {
    const fishGame = document.querySelector('.fishgame');
    const movingBox = document.createElement('div');
    movingBox.classList.add('moving-box');
    fishGame.appendChild(movingBox);

    const fishGameWrapper = document.querySelector('.fishgame-wrapper');
    const keyA = document.querySelector('.key-a');
    const keyD = document.querySelector('.key-d');
    const fish = document.querySelector('.fish');
    const progress = document.querySelector('.progress');

    movingBox.style.position = 'absolute';
    movingBox.style.top = '50%';
    movingBox.style.left = `${keyA.offsetLeft + keyA.offsetWidth}px`;

    let isMovingLeft = false; 
    let isMovingRight = false; 
    let isShaking = false; 
    let progressValue = 0;
    let wasFishInBox = false;
    let gameEnded = false;

    const moveSpeed = 1; 

    fishGameWrapper.classList.add('enter');

    function updateMovingBoxPosition() {
        const currentLeft = parseInt(movingBox.style.left || 0);
    
        if (isMovingLeft) {
            const newLeft = currentLeft - moveSpeed;
            if (newLeft >= keyA.offsetLeft + keyA.offsetWidth) {
                movingBox.style.left = `${newLeft}px`;
            }
        } else if (isMovingRight) {
            const newLeft = currentLeft + moveSpeed;
            if (newLeft + movingBox.offsetWidth <= keyD.offsetLeft) {
                movingBox.style.left = `${newLeft}px`;
            }
        }
    }

    function isFishInMovingBox() {
        const fishRect = fish.getBoundingClientRect();
        const boxRect = movingBox.getBoundingClientRect();
    
        const verticalTolerance = 60; 
        const horizontalTolerance = 25;
    
        return (
            fishRect.left >= boxRect.left - horizontalTolerance && 
            fishRect.right <= boxRect.right + horizontalTolerance &&
            fishRect.top + verticalTolerance >= boxRect.top &&
            fishRect.bottom - verticalTolerance <= boxRect.bottom
        );
    }

    function shakeMovingBox() {
        if (isShaking) {
            const randomOffsetX = Math.random() * shakeIntensity - shakeIntensity / 2;
            const currentLeft = parseInt(movingBox.style.left || 0);
            const newLeft = currentLeft + randomOffsetX;
        
            if (
                newLeft >= keyA.offsetLeft + keyA.offsetWidth && 
                newLeft + movingBox.offsetWidth <= keyD.offsetLeft 
            ) {
                movingBox.style.left = `${newLeft}px`;
            }
        }
    }

    function updateProgressBar() {
        const fishInBox = isFishInMovingBox();

        if (fishInBox) {
            wasFishInBox = true;
            if (progressValue < 109) {
                progressValue += 0.05;
            }
        } else {
            if (wasFishInBox) {
                endGame(false);
            }
            if (progressValue > 0) {
                progressValue -= 0.01;
            }
        }

        progress.style.width = `${progressValue}%`;

        if (progressValue >= 109) {
            endGame(true);
        }
    }

  
    function endGame(success) {
        if (gameEnded) return;
        gameEnded = true;

        console.log(success);
        fetch(`https://${GetParentResourceName()}/gameResult`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(success),
        });

        fishGameWrapper.classList.add('exit');
        setTimeout(() => {
            fishGameWrapper.style.display = 'none';
        }, 700);
    }

    function startGame() {
        isMovingLeft = false;
        isMovingRight = false;
        isShaking = false;
        progressValue = 0;
        wasFishInBox = false;
        gameEnded = false;
    
        progress.style.width = '0%';
        movingBox.style.left = `${keyA.offsetLeft + keyA.offsetWidth}px`;
    
        fishGameWrapper.classList.remove('exit');
        fishGameWrapper.classList.add('enter');
        fishGameWrapper.style.display = 'flex';
    }

    function animate() {
        updateMovingBoxPosition();

        if (isFishInMovingBox()) {
            isShaking = true;
        } else {
            isShaking = false;
        }

        updateProgressBar();
        shakeMovingBox();

        if (!gameEnded) {
            requestAnimationFrame(animate);
        }
    }

    document.addEventListener('keydown', (event) => {
        if (event.key === 'a' || event.key === 'A') {
            isMovingLeft = true;
            keyA.classList.add('key-pressed');
        } else if (event.key === 'd' || event.key === 'D') {
            isMovingRight = true;
            keyD.classList.add('key-pressed');
        }
    });

    document.addEventListener('keyup', (event) => {
        if (event.key === 'a' || event.key === 'A') {
            isMovingLeft = false;
            keyA.classList.remove('key-pressed');
        } else if (event.key === 'd' || event.key === 'D') {
            isMovingRight = false;
            keyD.classList.remove('key-pressed');
        }
    });

    window.addEventListener('message', function(event) {
        if (event.data.action === "showGame") {
            shakeIntensity = event.data.shakeIntensity || 6;
            startGame();
            animate();
        }
    });
});

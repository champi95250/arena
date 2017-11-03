function StartEndCamera() {
    var startSpeed = 0.8;
    var slowTo = 0.02;
    var slowOver = 3.0;
    var startTime = Game.GetGameTime()

    function SetCam(yaw) {
        if (Game.GetGameTime() - startTime < 8) {
            var diff = startSpeed;

            if (yaw < 45) {
                diff = ((1 - Math.min((45 - yaw) / slowOver, 1.0)) * (startSpeed - slowTo)) + slowTo;
            }

            if (Game.IsGamePaused()) {
                diff = 0;
            }

            $.Schedule(0.01, function() { SetCam(yaw - diff); });
        } else {
            GameUI.SetCameraYaw(0);
            GameUI.SetCameraPitchMin(60);
            GameUI.SetCameraPitchMax(60);
            GameUI.SetCameraLookAtPositionHeightOffset(100);
            GameUI.SetCameraDistance(0);

            return;
        }
        
        GameUI.SetCameraYaw(yaw);
        GameUI.SetCameraPitchMin(5);
        GameUI.SetCameraPitchMax(5);
        GameUI.SetCameraDistance(100);
        GameUI.SetCameraLookAtPositionHeightOffset(0);
    }

    SetCam(60);
}

GameEvents.Subscribe( "start_end_camera", StartEndCamera );
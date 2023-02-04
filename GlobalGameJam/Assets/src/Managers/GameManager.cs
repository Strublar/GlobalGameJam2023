using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    [SerializeField] private GameObject cameraObj;
    [SerializeField] private float shakeCoeff;
    [SerializeField] private float shakeDuration;
    [SerializeField] private MusicManager musicManager;
    [SerializeField] private Canvas mainMenuCanvas;
    [SerializeField] private TextMeshProUGUI scoreTxt;
    private int _score;
    
    
    
    private void Awake()
    {
        instance = this;
        mainMenuCanvas.enabled = false;
    }


    
    void Start()
    {
        scoreTxt.text = _score.ToString();
    }

    public void ToggleMainMenu()
    {
        mainMenuCanvas.enabled = !mainMenuCanvas.enabled;
        if (Time.deltaTime == 0)
        {
            Time.timeScale = 1;
        }
        else
        {
            Time.timeScale = 0;
        }
    }

    public void GameOn()
    {
        Time.timeScale = 1;
        mainMenuCanvas.enabled = false;
        // musicManager.
    }
    
    public void Death()
    {
        Time.timeScale = 0;
        mainMenuCanvas.enabled = true;
        _score = 0;
    }

    public void IncrementScore(int scoreAmount)
    {
        _score += scoreAmount;
        if (scoreAmount != 0)
        {
            scoreTxt.color = GetColorAccordingToScoreBoost(scoreAmount); // The color could be defined by consecutive root cuts            
        }
        ShakeCameraAccordingToScoreIncrease(scoreAmount);
        scoreTxt.text = _score.ToString();
        
    }
    private static Color GetColorAccordingToScoreBoost(int scoreAmount)
    {
        if (scoreAmount <= 1)
        {
            return Color.black;
        }

        if (scoreAmount <= 3)
        {
            return Color.yellow;
        }
        return Color.red;
    }

    private void ShakeCameraAccordingToScoreIncrease(int scoreAmount)
    {
        if (scoreAmount == 0)
        {
            return;
        }
        
        var shakeScore = shakeCoeff * scoreAmount;
        var shakeVector = new Vector3(shakeScore, shakeScore, shakeScore);
        Camera.main.DOShakePosition(shakeDuration, shakeVector, 20, 45f, false, ShakeRandomnessMode.Harmonic);
    }
    
}
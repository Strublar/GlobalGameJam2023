using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    [SerializeField] private GameObject cameraObj;
    [SerializeField] private float shakeCoeff;
    [SerializeField] private float shakeDuration;
    
    
    
    private void Awake()
    {
        instance = this;
    }

    [SerializeField] private TextMeshProUGUI scoreTxt;
    private int _score;
    
    void Start()
    {
        scoreTxt.text = _score.ToString();
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
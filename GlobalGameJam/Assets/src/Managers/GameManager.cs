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
    
    
    
    private void Awake()
    {
        instance = this;
    }

    [SerializeField] private TextMeshProUGUI scoreTxt;
    private int _score;

    // Start is called before the first frame update
    void Start()
    {
        scoreTxt.text = _score.ToString();

    }

    public void IncrementScore(int scoreAmount)
    {
        _score += scoreAmount;
        scoreTxt.color = GetColorAccordingToScoreBoost(scoreAmount);
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
        Camera.main.DOShakePosition(1, new Vector3(0.5f,0.5f,0.5f), 20, 45f, false, ShakeRandomnessMode.Harmonic);
    }

    // Update is called once per frame
    void Update()
    {
    }
}
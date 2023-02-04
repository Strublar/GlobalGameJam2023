using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    
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
        scoreTxt.text = _score.ToString();
        Debug.Log("current score :" + _score.ToString());
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

    // Update is called once per frame
    void Update()
    {
    }
}
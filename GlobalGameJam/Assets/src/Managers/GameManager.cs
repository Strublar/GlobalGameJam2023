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

    public void IncrementScore()
    {
        _score += 1;
        scoreTxt.text = _score.ToString();
        Debug.Log("current score :" + _score.ToString());
    }

    // Update is called once per frame
    void Update()
    {
    }
}
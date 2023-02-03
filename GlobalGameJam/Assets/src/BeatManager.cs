using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class BeatManager : MonoBehaviour
{
    public static UnityEvent Beat = new UnityEvent();

    [SerializeField] private float initialBeatPeriod;
    [SerializeField] private float beatMultiplierPerBeat;

    private float currentBeatPeriod;
    private float currentTimer = 0f;

    public void Start()
    {
        currentBeatPeriod = initialBeatPeriod;
        Beat.AddListener(UpdateBeat);
    }

    public void UpdateBeat()
    {
        Debug.Log("Beat");
        currentBeatPeriod *= beatMultiplierPerBeat;
    }

    public void Update()
    {
        currentTimer += Time.deltaTime;
        if (currentTimer >= currentBeatPeriod)
        {
            currentTimer = 0f;
            Beat.Invoke();
        }
    }
}
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BeatManager : MonoBehaviour
{
    public static UnityEvent Beat = new UnityEvent();

    [SerializeField] private float beatPeriod;
    private float currentTimer = 0f;
    public void Update()
    {
        currentTimer += Time.deltaTime;
        if (currentTimer >= beatPeriod)
        {
            currentTimer = 0f;
            Beat.Invoke();
        }
    }
}
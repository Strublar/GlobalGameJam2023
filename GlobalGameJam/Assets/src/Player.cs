using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    
    [SerializeField] private float dashForce;
    [SerializeField] private float dashDuration;
    [SerializeField] private Transform target;
    
    
    public void Awake()
    {
        BeatManager.Beat.AddListener(Dash);
    }

    private void Dash()
    {
        var position = transform.position;
        var direction = (target.position - position).normalized * dashForce;
        StartCoroutine(DashCoroutine(position,position+direction,0f));
    }

    IEnumerator DashCoroutine(Vector3 from, Vector3 to, float currentDuration)
    {
        while(currentDuration < dashDuration)
        {
            currentDuration += Time.deltaTime;
            transform.position = Vector3.Lerp(from, to, currentDuration / dashDuration);
            yield return null;
        }
    }
}

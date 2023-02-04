using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    [SerializeField] private float minDashForce;
    [SerializeField] private float maxDashForce;

    [SerializeField] private float minDashThreshold;
    [SerializeField] private float maxDashThreshold;

    [SerializeField] private float dashDuration;
    [SerializeField] private Transform target;


    public void Awake()
    {
        BeatManager.Beat.AddListener(Dash);
    }

    private void Dash()
    {
        var position = transform.position;
        var direction = target.position - position;

        var directionMagnitude = direction.magnitude;
        float dashForce;
        if (directionMagnitude <= minDashThreshold)
            dashForce = minDashForce;
        else if (directionMagnitude >= maxDashThreshold)
            dashForce = maxDashForce;
        else
        {
            dashForce = minDashForce + (directionMagnitude - minDashThreshold) * (maxDashForce - minDashForce) /
                (maxDashThreshold - minDashThreshold);
        }

        var forceVector = (target.position - position).normalized * dashForce;
        StartCoroutine(DashCoroutine(position, forceVector));
    }

    IEnumerator DashCoroutine(Vector3 from, Vector3 direction)
    {
        var currentDuration = 0f;
        while (currentDuration < dashDuration)
        {
            currentDuration += Time.deltaTime;
            transform.position = Vector3.Lerp(from, from + direction, currentDuration / dashDuration);
            yield return null;
        }

        RaycastHit[] hits = Physics.RaycastAll(from, direction, direction.magnitude);
        foreach (var hit in hits)
        {
            if(hit.transform.CompareTag("Root"))
            {
                Debug.Log("Root détecté" + hit.transform.name);
                hit.transform.GetComponentInParent<Root>().Cut();
            }
        }
    }
    
    


}
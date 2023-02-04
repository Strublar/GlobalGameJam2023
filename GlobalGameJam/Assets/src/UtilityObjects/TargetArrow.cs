using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetArrow : MonoBehaviour
{
    [SerializeField] private Player player;

    [SerializeField] private Transform mouseTarget;


    // Update is called once per frame
    void Update()
    {
        
        var directionMagnitude = (mouseTarget.position - player.transform.position).magnitude;
        
        float dashForce;
        if (directionMagnitude <= player.minDashThreshold)
            dashForce = player.minDashForce;
        else if (directionMagnitude >= player.maxDashThreshold)
            dashForce = player.maxDashForce;
        else
        {
            dashForce = player.minDashForce + (directionMagnitude - player.minDashThreshold) *
                (player.maxDashForce - player.minDashForce) /
                (player.maxDashThreshold - player.minDashThreshold);
        }
        
        transform.LookAt(mouseTarget);
        transform.localScale = new Vector3(1, 
            1, 
            dashForce);
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetArrow : MonoBehaviour
{
    [SerializeField] private Player player;

    [SerializeField] private Transform mouseTarget;

    [SerializeField] private GameObject dashPrevisualizationObject;


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

        Vector3 newPos = transform.position + (mouseTarget.position - player.transform.position).normalized * dashForce;
        float newEulerY = Quaternion.LookRotation(newPos - transform.position, new Vector3(0, 1, 0)).eulerAngles.y;

        UpdateDashPrevisualization(newPos, newEulerY);
    }

    public void UpdateDashPrevisualization(Vector3 newPos, float m_eulerY)
    {
        dashPrevisualizationObject.transform.position = new Vector3(newPos.x, dashPrevisualizationObject.transform.position.y, newPos.z);
        dashPrevisualizationObject.transform.eulerAngles = new Vector3(dashPrevisualizationObject.transform.eulerAngles.x, m_eulerY, dashPrevisualizationObject.transform.eulerAngles.z);
    }
}
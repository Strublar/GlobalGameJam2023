using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseTarget : MonoBehaviour
{

    [SerializeField] private Collider m_Plane;
    Vector3 m_DistanceFromCamera;

    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        
        if (m_Plane.Raycast(ray, out var enter,10000f))
        {
            transform.position = enter.point;
        }
    }
}
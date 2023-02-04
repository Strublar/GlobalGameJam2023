using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scissors : MonoBehaviour
{
    [SerializeField] private Transform mouseTarget;
    [SerializeField] private SpriteRenderer playerRenderer;

    void Update()
    {
        playerRenderer.flipX = (mouseTarget.transform.position - transform.position).x > 0;
        var lookPos = new Vector3(mouseTarget.position.x, 0, mouseTarget.position.y);
        transform.LookAt(mouseTarget);
        
    }

}

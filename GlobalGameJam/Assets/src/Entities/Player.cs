using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UIElements;

public class Player : MonoBehaviour
{
    public float minDashForce;
    public float maxDashForce;

    public float minDashThreshold;
    public float maxDashThreshold;

    [SerializeField] private AnimationCurve velocityCurve;

    [SerializeField] private float dashDuration;
    [SerializeField] private Transform target;


    public void Awake()
    {
        //BeatManager.Beat.AddListener(Dash);
    }

    #region Essais Landry

    [Header("Landry")] [SerializeField] private float maxChargeThreshold;
    [SerializeField] private float movementSpeed;
    [SerializeField] private float chargingMovementSpeed;
    
    
    [SerializeField] private float currentMovementSpeed;
    [SerializeField]private float chargeTime = 0f;

    private void Update()
    {
        var direction = target.position - transform.position;
        transform.position += direction.normalized * (currentMovementSpeed * Time.deltaTime);
        if (Input.GetMouseButton(0))
        {
            currentMovementSpeed = chargingMovementSpeed;
            chargeTime += Time.deltaTime;
        }
        else
        {
            currentMovementSpeed = movementSpeed;
        }

        if (Input.GetMouseButtonUp(0) && chargeTime > 0)
        {
            var position = transform.position;

            float dashForce;
            if (chargeTime >= maxChargeThreshold)
                dashForce = maxDashForce;
            else
            {
                dashForce = minDashForce + chargeTime * (maxDashForce - minDashForce) /
                    maxChargeThreshold;
            }

            var forceVector = (target.position - position).normalized * dashForce;
            StartCoroutine(DashCoroutine(position, forceVector));
            chargeTime = 0;
        }
    }

    #endregion


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
            var currentPoint = velocityCurve.Evaluate(currentDuration / dashDuration);
            transform.position = Vector3.Lerp(from, from + direction, currentPoint);
            yield return null;
        }

        RaycastHit[] hits = Physics.RaycastAll(from, direction, direction.magnitude);
        var rootCuts = Array.FindAll(hits, hit => hit.transform.CompareTag("Root"));
        foreach (var rootCut in rootCuts)
        {
            rootCut.transform.GetComponentInParent<Root>().Cut();
        }

        GameManager.instance.IncrementScore(rootCuts.Length);
        foreach (var hit in hits)
        {
            if (hit.transform.CompareTag("Wall"))
            {
                Debug.Log("Tu meurs parce que tu es rentré dans un" + hit.transform.tag);
                Time.timeScale = 0;
            }
        }
    }
}
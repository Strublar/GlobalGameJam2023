using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using DG.Tweening;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;
using Vector3 = UnityEngine.Vector3;

public class Player : MonoBehaviour
{
    public float minDashForce;
    public float maxDashForce;

    public float minDashThreshold;
    public float maxDashThreshold;

    [SerializeField] private AnimationCurve velocityCurve;

    [SerializeField] private float dashDuration;
    [SerializeField] private Transform target;

    public LayerMask dashPhysicsLayerMask;


    [SerializeField] private float playerPunchScalePower;
    [SerializeField] private float playerPunchScaleDuration;

    private bool almightyScissors = false;
    


    [SerializeField] private Animator scissorsAnimator;
    
    public void Awake()
    {
        BeatManager.Beat.AddListener(Dash);
        BeatManager.OffBeat.AddListener(OnOffBeat);
    }

    #region Essais Landry

    /*[Header("Landry")] [SerializeField] private float maxChargeThreshold;
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
    }*/

    #endregion

    private void OnOffBeat()
    {
        transform.DOPunchScale(Vector3.one * playerPunchScalePower, playerPunchScaleDuration);
        scissorsAnimator.Play("DashIdle");
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
        scissorsAnimator.Play("WeaponSlash");
        var currentDuration = 0f;
        while (currentDuration < dashDuration)
        {
            currentDuration += Time.deltaTime;
            var currentPoint = velocityCurve.Evaluate(currentDuration / dashDuration);
            transform.position = Vector3.Lerp(from, from + direction, currentPoint);
            yield return null;
        }

        RaycastHit[] hits = Physics.RaycastAll(from, direction, direction.magnitude, dashPhysicsLayerMask.value);
        /*
        var rootCuts = Array.FindAll(hits, hit => hit.transform.CompareTag("Root"));
        foreach (var rootCut in rootCuts)
        {
            rootCut.transform.GetComponentInParent<RootVisual>().CutRoot(UnityEngine.Random.Range(0.1f,0.8f));
            //hits
            //FIND OUT WHERE WE HIT THE ROOT
        }*/
        
        for (int i = 0; i < hits.Length; i++)
        {
            RaycastHit hit = hits[i];
            if (hit.transform.CompareTag("Root")) 
            {
                RootVisual hittedRoot = hit.transform.GetComponentInParent<RootVisual>();
                float hittedLocalPoint = hittedRoot.transform.InverseTransformPoint(hit.point).y / 2;
                if (hittedRoot.m_rootProgression > hittedLocalPoint/1.5f) 
                {
                    hittedRoot.CutRoot(hittedLocalPoint);

                }

                // Debug.LogWarning(hit.transform.GetComponentInParent<RootVisual>().transform.InverseTransformPoint(hit.point).y/2);

            }
        }

        
        foreach (var hit in hits)
        {
            if (hit.transform.CompareTag("Wall"))
            {
                if (almightyScissors)
                {
                    Destroy(hit.transform.gameObject);
                    // Display SMASH (ou un truc dans le genre pour dire qu'on a détruit un mur)
                }
                else
                {
                    GameManager.instance.Death();
                }
                
            }
        }
    }

    public void SetAlmightyScissors()
    {
        almightyScissors = true;
    }
}
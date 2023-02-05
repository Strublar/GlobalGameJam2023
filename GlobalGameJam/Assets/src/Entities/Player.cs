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

    [SerializeField] private float scissorsRange;
    

    [SerializeField] private AnimationCurve velocityCurve;

    [SerializeField] private float dashDuration;
    [SerializeField] private Transform target;

    public LayerMask dashPhysicsLayerMask;


    [SerializeField] private float playerPunchScalePower;
    [SerializeField] private float playerPunchScaleDuration;

    private bool almightyScissors;
    


    [SerializeField] private Animator scissorsAnimator;

    [SerializeField] private GameObject DistortionFX;
    [SerializeField] private GameObject fireOverlay;
    

    public void Awake()
    {
        BeatManager.Beat.AddListener(Dash);
        BeatManager.OffBeat.AddListener(OnOffBeat);
    }

    private void OnOffBeat()
    {
        if (almightyScissors)
        {
            scissorsAnimator.Play("IdleDashFeu");
        }else
        {
            scissorsAnimator.Play("IdleDash");
        }
        
    }

    private void Dash()
    {
        transform.DOPunchScale(Vector3.one * playerPunchScalePower, playerPunchScaleDuration);
        
        
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
        //scissorsAnimator.Play("WeaponSlash");
        
        var targetPosition = from + direction;

        RaycastHit[] bodyHits = Physics.RaycastAll(from, direction, direction.magnitude, dashPhysicsLayerMask.value);
        RaycastHit[] cutHits = Physics.RaycastAll(from, direction, direction.magnitude + scissorsRange);
        
        var wallsHit = Array.FindAll(bodyHits, hit => hit.transform.CompareTag("Wall"));
        if (wallsHit.Length != 0 && !almightyScissors)
        {
            GameManager.instance.Death();    
            /*if (almightyScissors)
            {
                GameManager.instance.IncrementScoreWhileOnPowerUp(wallsHit.Length);
                foreach (var hit in wallsHit)
                {
                    Destroy(hit.transform.gameObject.GetComponentInParent<RootVisual>().gameObject);
                }
            
            }
            else
            {
                
            }*/
        }
        foreach (var hit in cutHits)
        {
            if (hit.transform.CompareTag("Root")) 
            {
                RootVisual hittedRoot = hit.transform.GetComponentInParent<RootVisual>();
                float hittedLocalPoint = hittedRoot.transform.InverseTransformPoint(hit.point).y / 2;
                if (hittedRoot.m_rootProgression > hittedLocalPoint/1.5f) 
                {
                    hittedRoot.CutRoot(hittedLocalPoint);
                    Instantiate(DistortionFX, targetPosition, UnityEngine.Quaternion.identity);
                }
            }
        }
        
        var wallsCut = Array.FindAll(cutHits, hit => hit.transform.CompareTag("Wall"));
        if (almightyScissors && wallsCut.Length > 0)
        {
            GameManager.instance.IncrementScoreWhileOnPowerUp(wallsHit.Length);
            foreach (var hit in wallsCut)
            {
                Destroy(hit.transform.gameObject.GetComponentInParent<RootVisual>().linkedFlower);
                Destroy(hit.transform.gameObject.GetComponentInParent<RootVisual>().gameObject);
                Instantiate(DistortionFX, targetPosition, UnityEngine.Quaternion.identity);
            }
        }
        
        
        var currentDuration = 0f;
        while (currentDuration < dashDuration)
        {
            currentDuration += Time.deltaTime;
            var currentPoint = velocityCurve.Evaluate(currentDuration / dashDuration);
            transform.position = Vector3.Lerp(from, targetPosition, currentPoint);
            yield return null;
        }

        
        
    }

    public void SetAlmightyScissors()
    {
        almightyScissors = true;
        fireOverlay.SetActive(true);
        //scissorsAnimator.gameObject.GetComponent<SpriteRenderer>().color = Color.red;
    }

    public void ResetAlmightyScissors()
    {
        almightyScissors = false;
        fireOverlay.SetActive(false);
        scissorsAnimator.gameObject.GetComponent<SpriteRenderer>().color = Color.white;
    }
}
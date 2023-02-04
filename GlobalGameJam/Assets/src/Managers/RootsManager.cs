using UnityEngine;
using UnityEngine.Serialization;

namespace src
{
    public class RootsManager : MonoBehaviour
    {
        [Header("Root behaviour")] 
        public float expandDuration;

        [Header("Root generation management")]
        [SerializeField] private GameObject rootPrefab;
        [SerializeField] private float baseSpawnPeriod;
        [SerializeField] private float spawnPeriodMultiplierPerSpawn;
        
        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;
        
        [Header("Spawn point management")]
        [SerializeField] private GameObject spawnPointContainer;
        [SerializeField] private GameObject rootContainer;

        private float currentSpawnPeriod;
        private float currentTimer = 0f;
        public static RootsManager _instance { get; private set; }

        private void Awake()
        {
            if (_instance != null && _instance != this)
            {
                Destroy(this);
            }
            else
            {
                _instance = this;
            }

            currentSpawnPeriod = baseSpawnPeriod;
        }
        
        public void SpawnRoot()
        {
            SpawnPoint[] availableSpawnPoints = spawnPointContainer.GetComponentsInChildren<SpawnPoint>();
            SpawnPoint selectedSpawnPoint = availableSpawnPoints[Random.Range(0, availableSpawnPoints.Length)];
            SpawnRootAtTarget(selectedSpawnPoint);

        }

        public void SpawnRootAtTarget(SpawnPoint selectedSpawnPoint)
        {
            Transform selectedTransform = selectedSpawnPoint.transform;
            var instantiatedRoot = Instantiate(rootPrefab, selectedTransform.position,
                selectedTransform.rotation, rootContainer.transform);
            instantiatedRoot.GetComponent<Root>().Init(selectedSpawnPoint,selectedSpawnPoint.getRandomNeighbour(),this);
        }

        void Update()
        {
            currentTimer += Time.deltaTime;
            if (currentTimer >= currentSpawnPeriod)
            {
                currentTimer = 0f;
                currentSpawnPeriod *= spawnPeriodMultiplierPerSpawn;
                SpawnRoot();
            }
        }

        public float GetMinRootRange()
        {
            return minRootRange;
        }
        public float GetMaxRootRange()
        {
            return maxRootRange;
        }
    }
}
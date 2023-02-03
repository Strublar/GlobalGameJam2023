using UnityEngine;

namespace src
{
    public class RootsManager : MonoBehaviour
    {
        [SerializeField] private GameObject rootPrefab;
        [SerializeField] private float spawnPeriod;
        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;
        [SerializeField] private GameObject spawnPointContainer;
        [SerializeField] private GameObject rootContainer;

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
        }

        // Start is called before the first frame update
        void Start()
        {
        }

        // Update is called once per frame

        public void SpawnRoot()
        {
            var availableSpawnPoints = spawnPointContainer.GetComponentsInChildren<SpawnPoint>();
            var selectedSpawnPoint = availableSpawnPoints[Random.Range(0, availableSpawnPoints.Length)];
            var selectedTransform = selectedSpawnPoint.transform;
            var instantiatedRoot = Instantiate(rootPrefab, selectedTransform.position,
                selectedTransform.rotation, rootContainer.transform);
            
            instantiatedRoot.transform.LookAt(selectedSpawnPoint.getRandomNeighbour());
        }

        void Update()
        {
            currentTimer += Time.deltaTime;
            if (currentTimer >= spawnPeriod)
            {
                currentTimer = 0f;
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
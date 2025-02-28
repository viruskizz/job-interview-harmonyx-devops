import http from 'k6/http';
import { sleep, check } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('error_rate');
const apiLatency = new Trend('api_latency');
const throughputCounter = new Trend('throughput');

// PERFORMANCE ISSUES:
// 1. No proper load test stages for ramp-up/down
// 2. No proper thresholds defined
// 3. Limited metrics collection
// 4. No proper virtual user distribution
// 5. No cache busting or realistic user behavior

export const options = {
  // ISSUE: Insufficient VUs for large-scale testing
  vus: 10,
  
  // ISSUE: Only testing for a short duration
  duration: '30s',
  
  // ISSUE: No proper stages for ramp-up/down
  
  // ISSUE: Basic thresholds only
  thresholds: {
    // Expect 95% of requests to complete within 1s
    http_req_duration: ['p(95)<1000'],
    
    // Error rate should be less than 1%
    error_rate: ['rate<0.01'],
  },
};

export default function () {
  // Test scenario for user management API
  
  // ISSUE: No proper test grouping or scenarios
  
  // Get all users
  let getUsersResponse = http.get('http://localhost:5000/api/users');
  
  // ISSUE: Basic checks only
  check(getUsersResponse, {
    'users status is 200': (r) => r.status === 200,
  });
  
  // Record metrics
  errorRate.add(getUsersResponse.status !== 200);
  apiLatency.add(getUsersResponse.timings.duration);
  throughputCounter.add(1);
  
  // Create a user
  const payload = JSON.stringify({
    username: `user_${Math.floor(Math.random() * 10000)}`,
    password: 'password123',
    email: `user_${Math.floor(Math.random() * 10000)}@example.com`,
  });
  
  // ISSUE: Not using content-type header consistently
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  
  let createUserResponse = http.post('http://localhost:5000/api/users', payload, params);
  
  check(createUserResponse, {
    'create user status is 201': (r) => r.status === 201,
  });
  
  // Record metrics
  errorRate.add(createUserResponse.status !== 201);
  apiLatency.add(createUserResponse.timings.duration);
  throughputCounter.add(1);
  
  // Search for users
  let searchResponse = http.get('http://localhost:5000/api/search?q=user');
  
  check(searchResponse, {
    'search status is 200': (r) => r.status === 200,
  });
  
  // Record metrics
  errorRate.add(searchResponse.status !== 200);
  apiLatency.add(searchResponse.timings.duration);
  throughputCounter.add(1);
  
  // ISSUE: Not simulating realistic user behavior with proper think time
  sleep(1);
}

// ISSUE: No setup/teardown functions for proper test initialization/cleanup
// ISSUE: No data generation for large-scale testing
// ISSUE: No proper reporting or integration with monitoring systems
// ISSUE: No parallel request execution for realistic load testing

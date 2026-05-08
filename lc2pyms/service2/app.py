"""
Service 2 - Data Analytics Microservice
Demonstrates authentication integration with data processing endpoints
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
import sys
import os
import logging
from datetime import datetime, timedelta
import random

# Add parent directory to path to import shared module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from shared.auth_client import AuthClient, require_auth, get_token_from_request

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize auth client
AUTH_SERVICE_URL = os.environ.get('AUTH_SERVICE_URL', 'http://localhost:8000')
auth_client = AuthClient(AUTH_SERVICE_URL)

# In-memory analytics data (for demonstration)
analytics_data = {}


def generate_sample_data(username, days=7):
    """Generate sample analytics data"""
    data = []
    for i in range(days):
        date = (datetime.now() - timedelta(days=days-i-1)).strftime('%Y-%m-%d')
        data.append({
            'date': date,
            'views': random.randint(100, 1000),
            'clicks': random.randint(10, 100),
            'conversions': random.randint(1, 20)
        })
    return data


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    auth_healthy = auth_client.health_check()
    return jsonify({
        'status': 'healthy',
        'service': 'data-analytics',
        'auth_service': 'connected' if auth_healthy else 'disconnected'
    }), 200


@app.route('/api/analytics/dashboard', methods=['GET'])
@require_auth(auth_client)
def get_dashboard(username):
    """
    Get analytics dashboard data (protected endpoint)
    Requires: Authorization: Bearer <token>
    """
    try:
        # Generate or retrieve analytics data
        if username not in analytics_data:
            analytics_data[username] = generate_sample_data(username)
        
        data = analytics_data[username]
        
        # Calculate summary statistics
        total_views = sum(d['views'] for d in data)
        total_clicks = sum(d['clicks'] for d in data)
        total_conversions = sum(d['conversions'] for d in data)
        
        return jsonify({
            'username': username,
            'summary': {
                'total_views': total_views,
                'total_clicks': total_clicks,
                'total_conversions': total_conversions,
                'conversion_rate': round((total_conversions / total_clicks * 100), 2) if total_clicks > 0 else 0
            },
            'daily_data': data
        }), 200
    
    except Exception as e:
        logger.error(f"Error getting dashboard: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/analytics/report', methods=['POST'])
@require_auth(auth_client)
def generate_report(username):
    """
    Generate analytics report (protected endpoint)
    Requires: Authorization: Bearer <token>
    Request body: {"start_date": "YYYY-MM-DD", "end_date": "YYYY-MM-DD", "metrics": ["views", "clicks"]}
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        metrics = data.get('metrics', ['views', 'clicks', 'conversions'])
        
        # Generate or retrieve analytics data
        if username not in analytics_data:
            analytics_data[username] = generate_sample_data(username)
        
        user_data = analytics_data[username]
        
        # Filter data by date range if provided
        if start_date and end_date:
            filtered_data = [
                d for d in user_data
                if start_date <= d['date'] <= end_date
            ]
        else:
            filtered_data = user_data
        
        # Calculate metrics
        report = {
            'username': username,
            'period': {
                'start': start_date or filtered_data[0]['date'] if filtered_data else None,
                'end': end_date or filtered_data[-1]['date'] if filtered_data else None
            },
            'metrics': {}
        }
        
        for metric in metrics:
            if metric in ['views', 'clicks', 'conversions']:
                total = sum(d.get(metric, 0) for d in filtered_data)
                avg = total / len(filtered_data) if filtered_data else 0
                report['metrics'][metric] = {
                    'total': total,
                    'average': round(avg, 2)
                }
        
        return jsonify({
            'success': True,
            'report': report
        }), 200
    
    except Exception as e:
        logger.error(f"Error generating report: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/analytics/export', methods=['GET'])
@require_auth(auth_client)
def export_data(username):
    """
    Export analytics data (protected endpoint)
    Requires: Authorization: Bearer <token>
    Query params: ?format=json|csv
    """
    try:
        export_format = request.args.get('format', 'json')
        
        # Generate or retrieve analytics data
        if username not in analytics_data:
            analytics_data[username] = generate_sample_data(username)
        
        data = analytics_data[username]
        
        if export_format == 'csv':
            # Generate CSV format
            csv_lines = ['date,views,clicks,conversions']
            for row in data:
                csv_lines.append(f"{row['date']},{row['views']},{row['clicks']},{row['conversions']}")
            
            return '\n'.join(csv_lines), 200, {
                'Content-Type': 'text/csv',
                'Content-Disposition': f'attachment; filename=analytics_{username}.csv'
            }
        else:
            # Return JSON format
            return jsonify({
                'username': username,
                'data': data,
                'exported_at': datetime.now().isoformat()
            }), 200
    
    except Exception as e:
        logger.error(f"Error exporting data: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/analytics/refresh', methods=['POST'])
@require_auth(auth_client)
def refresh_data(username):
    """
    Refresh analytics data (protected endpoint)
    Requires: Authorization: Bearer <token>
    """
    try:
        # Generate new sample data
        analytics_data[username] = generate_sample_data(username)
        
        return jsonify({
            'success': True,
            'message': 'Analytics data refreshed',
            'data_points': len(analytics_data[username])
        }), 200
    
    except Exception as e:
        logger.error(f"Error refreshing data: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/public/info', methods=['GET'])
def public_info():
    """Public endpoint (no authentication required)"""
    return jsonify({
        'service': 'Data Analytics Service',
        'version': '1.0.0',
        'description': 'Provides analytics and reporting capabilities',
        'endpoints': {
            'public': ['/health', '/api/public/info'],
            'protected': [
                '/api/analytics/dashboard',
                '/api/analytics/report',
                '/api/analytics/export',
                '/api/analytics/refresh'
            ]
        }
    }), 200


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({'error': 'Endpoint not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8002))
    logger.info(f"Starting Data Analytics Service on port {port}")
    logger.info(f"Auth service URL: {AUTH_SERVICE_URL}")
    app.run(host='0.0.0.0', port=port, debug=False)

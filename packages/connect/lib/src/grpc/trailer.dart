// Copyright 2024-2025 The Connect Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:connectrpc/src/exception.dart';
import 'package:connectrpc/src/grpc/headers.dart';

import '../code.dart';
import '../headers.dart';
import 'status.dart';
import 'trailer_error.dart';

extension TrailerValidation on Headers {
  /// Validates a trailer for the gRPC and the gRPC-web protocol.
  /// Throws a [ConnectException] if the trailer contains an error status.
  void validateTrailer(
    Headers headers,
    StatusParser statusParser,
  ) {
    final err = findError(statusParser);
    if (err != null) {
      for (final header in headers.entries) {
        err.metadata.add(header.name, header.value);
      }
      throw err;
    }
    if (!contains(headerGrpcStatus) &&
        !contains(headerStatusDetailsBin) &&
        !headers.contains(headerGrpcStatus) &&
        !headers.contains(headerStatusDetailsBin)) {
      throw ConnectException(
        Code.internal,
        'protocol error: missing status',
      );
    }
  }
}
